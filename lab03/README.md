# ☕ LeCafe AWS LocalStack Project

## Description
Simulation of AWS services using LocalStack (S3, SQS, EC2, IAM).

---

## Steps

### 1. Start LocalStack
localstack start -d

### 2. Create IAM Role
awslocal iam create-role --role-name lecafe-app-role --assume-role-policy-document file://trust-policy.json

### 3. Attach Policy
awslocal iam put-role-policy --role-name lecafe-app-role --policy-name LeCafe-App-Permissions --policy-document file://app-role-policy.json

### 4. Create S3 Bucket
awslocal s3 mb s3://lecafe-assets

### 5. Upload file
echo "config" > config.txt
awslocal s3 cp config.txt s3://lecafe-assets/app/config.txt

### 6. Create SQS Queue
awslocal sqs create-queue --queue-name lecafe-orders

### 7. Create Key Pair
awslocal ec2 create-key-pair --key-name lecafe-keypair --query 'KeyMaterial' --output text > lecafe-keypair.pem

### 8. Create Security Group
awslocal ec2 create-security-group --group-name lecafe-app-sg --description "LeCafe SG"

### 9. Launch EC2
awslocal ec2 run-instances --image-id ami-0c02fb55956c7d316 --instance-type t3.micro

---

## Cleanup
awslocal s3 rm s3://lecafe-assets --recursive
awslocal sqs delete-queue --queue-url <QUEUE_URL>
awslocal ec2 terminate-instances --instance-ids <INSTANCE_ID>
localstack stop

---

## Author
Firas Khdhir
