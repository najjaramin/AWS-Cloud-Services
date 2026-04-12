# ☁️ Lab: SNS → SQS Fanout with LocalStack (Le Café Project)

## 🎯 Objective
This lab demonstrates an AWS event-driven architecture using SNS and SQS with LocalStack.

---

## 🧱 Architecture

- SNS Topic: `lecafe-orders-topic`
- SQS Queues:
  - Inventory Service
  - Loyalty Service
  - Manager Alerts Service (with filtering)

---

## 🚀 Execution Results

### 📌 SNS Topic Created

```text
arn:aws:sns:us-east-1:000000000000:lecafe-orders-topic

lecafe-inventory-updates
lecafe-loyalty-points
lecafe-manager-alerts

{
  "Protocol": "sqs",
  "Endpoint": "arn:aws:sqs:000000000000:lecafe-inventory-updates"
}

📡 Message Publishing Results
🟢 HIGH Priority Order
Message: HIGH ORDER TEST
Priority: high
📥 Inventory Queue Output
{
  "Type": "Notification",
  "Message": "{orderId:ORD-1,total:40}",
  "MessageAttributes": {
    "Priority": {
      "Type": "String",
      "Value": "high"
    }
  }
}

✔ Inventory received HIGH order

📥 Loyalty Queue Output
✔ Received HIGH priority order
✔ Received NORMAL order
📥 Manager Queue Output
{
  "Type": "Notification",
  "Message": "{orderId:ORD-1,total:40}",
  "MessageAttributes": {
    "Priority": {
      "Type": "String",
      "Value": "high"
    }
  }
}


📡 NORMAL Order Test
Message: NORMAL ORDER TEST
Priority: normal


Manager ❌ (if filter active)
📥 SQS Receive Message Sample
{
  "MessageId": "d977c9cb-eca9-4cc5-b834-eef1151e5730",
  "Body": {
    "Type": "Notification",
    "TopicArn": "lecafe-orders-topic",
    "Message": "{orderId:ORD-1,total:40}",
    "MessageAttributes": {
      "Priority": {
        "Type": "String",
        "Value": "high"
      }
    }
  }
}