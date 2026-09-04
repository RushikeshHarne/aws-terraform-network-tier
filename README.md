# 🌐 Network Infrastructure Tier (Repo 2)
---
## This repository provisions the foundational AWS Networking layer (VPC, Public/Private Subnets, and Internet Gateway) using Terraform. It integrates with a centralized remote state architecture and uses AWS SSM Parameter Store as a pipeline bridge to pass network configurations to downstream application stacks.
---
## 🏗️ Architecture Overview
---
```text
+-----------------------------------+
                  |  Repo 1: Bootstrap Infrastructure |
                  +-----------------------------------+
                                    |
                    Publishes Central S3 State Bucket
                                    v
                 +--------------------------------------+
                 |  AWS SSM Parameter Store             |
                 |  /terraform/remote_state_bucket      |
                 +--------------------------------------+
                                    |
                        Discovered dynamically at init
                                    v
                  +-----------------------------------+
                  |   Repo 2: Network Infrastructure  |
                  |            (THIS REPO)            |
                  +-----------------------------------+
                                    |
          +-------------------------+-------------------------+
          |                                                   |
          v                                                   v
  Provisions AWS Resources:                         Publishes Parameters:
  - Custom VPC (10.0.0.0/16)                        - /network/vpc_id
  - Public Subnet (10.0.1.0/24)                     - /network/private_subnet_id
  - Private Subnet (10.0.2.0/24)
  - Internet Gateway
                                                              |
                                                    Consumed by Repo 3 (App Stack)
```
---
## ✨ Key Features
---
1. 📦 Centralized State Management: Stores .tfstate in the central S3 bucket provisioned by Repo 1.

2. 🔒 Native S3 Lockfile: Uses Terraform 1.10+ native state locking (use_lockfile = true), eliminating DynamoDB requirements.

3. 🔗 Dynamic Cross-Repo Discovery: Registers Network IDs in AWS SSM Parameter Store so downstream repos (Repo 3 / App Tier) can consume them dynamically.

4. 🚀 Unified CI/CD Pipeline: Automated testing, plan verification, branch deployment, and manual teardown controls via GitHub Actions.
---
## 📁 Directory Structure
---
```text
.
├── .github/
│   └── workflows/
│       └── deploy.yml      # CI/CD Pipeline (PR, Apply, Destroy)
├── backend.tf              # Backend configuration pointing to central S3 bucket
├── main.tf                 # VPC, Subnets, Internet Gateway, and SSM Exports
├── variables.tf            # Input variable definitions and defaults
├── outputs.tf              # Module outputs (VPC and Subnet IDs)
└── README.md               # Project documentation
```
---
## 🌉 Pipeline Bridge (SSM Parameter Store)
---
This repository exports the following parameters to AWS SSM upon successful terraform apply:

```text
SSM Parameter Name                     Description                    Exported Value               Consumed By
/network/vpc_id                 ID of the provisioned main VPC        aws_vpc.main.id             Repo 3(AppTier)
/network/private_subnet_id      ID of the private subnet              aws_subnet.private.id       Repo 3 (App Tier)
```
