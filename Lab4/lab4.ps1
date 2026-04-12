# =========================
# 0. Start LocalStack (if not running)
# =========================
$env:LOCALSTACK_AUTH_TOKEN = "PUT_YOUR_TOKEN_HERE"   # optional if needed
$env:AWS_DEFAULT_REGION = "us-east-1"

# =========================
# 1. Create SNS Topic
# =========================
$TOPIC_ARN = awslocal sns create-topic --name lecafe-orders-topic --query "TopicArn" --output text
Write-Host "Topic ARN: $TOPIC_ARN"

# =========================
# 2. Create SQS Queues
# =========================
$INVENTORY_QUEUE_URL = awslocal sqs create-queue --queue-name lecafe-inventory-updates --query "QueueUrl" --output text
$LOYALTY_QUEUE_URL   = awslocal sqs create-queue --queue-name lecafe-loyalty-points   --query "QueueUrl" --output text
$MANAGER_QUEUE_URL   = awslocal sqs create-queue --queue-name lecafe-manager-alerts   --query "QueueUrl" --output text

Write-Host "Queues created"

# =========================
# 3. Get Queue ARNs
# =========================
$INVENTORY_ARN = awslocal sqs get-queue-attributes --queue-url $INVENTORY_QUEUE_URL --attribute-names QueueArn --query "Attributes.QueueArn" --output text
$LOYALTY_ARN   = awslocal sqs get-queue-attributes --queue-url $LOYALTY_QUEUE_URL   --attribute-names QueueArn --query "Attributes.QueueArn" --output text
$MANAGER_ARN    = awslocal sqs get-queue-attributes --queue-url $MANAGER_QUEUE_URL   --attribute-names QueueArn --query "Attributes.QueueArn" --output text

# =========================
# 4. Allow SNS to publish to SQS
# =========================
function Set-SNSPolicy($queueUrl, $queueArn) {
    $scriptDir = if ($PSScriptRoot) { $PSScriptRoot } else { (Get-Location).Path }

    $policyObj = @{
        Version = "2012-10-17"
        Statement = @(
            @{
                Sid = "AllowSNSPublish"
                Effect = "Allow"
                Principal = @{ Service = "sns.amazonaws.com" }
                Action = "sqs:SendMessage"
                Resource = $queueArn
                Condition = @{
                    ArnEquals = @{
                        "aws:SourceArn" = $TOPIC_ARN
                    }
                }
            }
        )
    }

    $policyJson = $policyObj | ConvertTo-Json -Depth 10 -Compress
    $policyFile = Join-Path $scriptDir "sqs-policy-$($queueArn.Split(':')[-1]).json"
    @{ Policy = $policyJson } | ConvertTo-Json -Compress | Set-Content -Path $policyFile -Encoding Ascii

    $policyPath = (Resolve-Path $policyFile).Path
    awslocal sqs set-queue-attributes `
      --queue-url $queueUrl `
      --attributes "file://$policyPath"
}

Set-SNSPolicy $INVENTORY_QUEUE_URL $INVENTORY_ARN
Set-SNSPolicy $LOYALTY_QUEUE_URL   $LOYALTY_ARN
Set-SNSPolicy $MANAGER_QUEUE_URL   $MANAGER_ARN

Write-Host "Policies applied"

# =========================
# 5. Subscribe queues to SNS
# =========================
awslocal sns subscribe --topic-arn $TOPIC_ARN --protocol sqs --notification-endpoint $INVENTORY_ARN
awslocal sns subscribe --topic-arn $TOPIC_ARN --protocol sqs --notification-endpoint $LOYALTY_ARN
awslocal sns subscribe --topic-arn $TOPIC_ARN --protocol sqs --notification-endpoint $MANAGER_ARN

Write-Host "Subscriptions done"

# =========================
# 6. Add filter policy (manager only high priority)
# =========================
$scriptDir = if ($PSScriptRoot) { $PSScriptRoot } else { (Get-Location).Path }
$filterPolicyPath = Join-Path $scriptDir "manager-filter.json"
@{ Priority = @("high") } | ConvertTo-Json -Compress | Set-Content -Path $filterPolicyPath -Encoding Ascii

$MANAGER_SUB_ARN = awslocal sns list-subscriptions-by-topic `
  --topic-arn $TOPIC_ARN `
  --query "Subscriptions[?Endpoint=='$MANAGER_ARN'].SubscriptionArn" `
  --output text

awslocal sns set-subscription-attributes `
  --subscription-arn $MANAGER_SUB_ARN `
  --attribute-name FilterPolicy `
  --attribute-value "file://$filterPolicyPath"

Write-Host "Filter applied"

# =========================
# 7. TEST publish message
# =========================
$highMsgAttribPath = Join-Path $scriptDir "message-attributes-high.json"
$normalMsgAttribPath = Join-Path $scriptDir "message-attributes-normal.json"
@{ Priority = @{ DataType = "String"; StringValue = "high" } } | ConvertTo-Json -Compress | Set-Content -Path $highMsgAttribPath -Encoding Ascii
@{ Priority = @{ DataType = "String"; StringValue = "normal" } } | ConvertTo-Json -Compress | Set-Content -Path $normalMsgAttribPath -Encoding Ascii

awslocal sns publish `
  --topic-arn $TOPIC_ARN `
  --message '{"orderId":"ORD-1","total":40}' `
  --message-attributes "file://$highMsgAttribPath"

awslocal sns publish `
  --topic-arn $TOPIC_ARN `
  --message '{"orderId":"ORD-2","total":10}' `
  --message-attributes "file://$normalMsgAttribPath"

Write-Host "Messages published"

# =========================
# 8. Check queues
# =========================
awslocal sqs get-queue-attributes --queue-url $INVENTORY_QUEUE_URL --attribute-names ApproximateNumberOfMessages
awslocal sqs get-queue-attributes --queue-url $LOYALTY_QUEUE_URL   --attribute-names ApproximateNumberOfMessages
awslocal sqs get-queue-attributes --queue-url $MANAGER_QUEUE_URL   --attribute-names ApproximateNumberOfMessages