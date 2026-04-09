# ☕ Lab 00 — Discover AWS Locally with LocalStack

**Series:** Le Café — AWS Hands-On Labs with LocalStack  
**Level:** Beginner  
**Duration:** ~60 minutes  
**Prerequisites:** Docker, Python 3.8+, AWS CLI  

---

## 🎯 Learning Objectives

By the end of this lab, you will be able to:

- Explain what LocalStack is and why it exists  
- Install and start LocalStack on your machine  
- Configure the AWS CLI to interact with LocalStack instead of real AWS  
- Use AWS services locally (S3, IAM, SQS)  
- Understand how LocalStack fits into a DevOps workflow  

---

## 🏪 Scenario — Le Café

You have joined **Le Café**, a growing coffee-shop chain migrating to AWS.

Your mission:
- Set up a local AWS environment using LocalStack  
- Interact with AWS services locally  
- Validate your setup by creating and using real cloud-like resources (offline)

---

## 🧠 What is LocalStack?

LocalStack is an open-source tool that emulates AWS services locally.

- Runs in Docker
- Exposes AWS-compatible APIs
- Available at: `http://localhost:4566`
- No real AWS account or billing required

👉 Think of it as a **simulator for AWS** where:
- API calls behave like AWS
- Resources are stored locally
- No internet or cloud required

---

## 🏗️ Architecture Overview

- Your CLI (AWS CLI / awslocal)
- LocalStack container (Docker)
- AWS-compatible API endpoints
- Local in-memory services (S3, SQS, IAM, etc.)

---

## ⚙️ Part 1 — Installation

### 1. Install Docker

Ensure Docker is installed and running:

```bash
docker --version
docker ps