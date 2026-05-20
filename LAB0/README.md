# LAB0 - AWS Cloud Service Lab

This repository contains AWS IAM policy configurations and cloud service documentation for the LAB0 project.

## Overview

LAB0 is a foundational AWS cloud service lab that demonstrates:
- AWS Identity and Access Management (IAM) policy configuration
- Role-based access control (RBAC)
- S3 bucket policies and permissions
- EC2 instance role assumption

## Project Structure

```
LAB0/
├── README.md              # This file
├── menu.txt               # Menu configuration
├── menu-downloaded.txt    # Downloaded menu items
└── ../lab01/              # Related lab files
    ├── developer-s3-policy.json
    ├── operations-policy.json
    └── trust-policy.json
```

## AWS IAM Policies

### 1. Developer S3 Policy
Provides full S3 access for development team members.
- **Location**: `../lab01/developer-s3-policy.json`
- **Permissions**: All S3 operations (`s3:*`)
- **Resources**: All (`*`)

### 2. Operations Policy
Provides read-only S3 access for operations team.
- **Location**: `../lab01/operations-policy.json`
- **Permissions**: 
  - `s3:GetObject`
  - `s3:ListBucket`
- **Resources**: All (`*`)

### 3. Trust Policy
Allows EC2 instances to assume IAM roles.
- **Location**: `../lab01/trust-policy.json`
- **Principal**: EC2 service (`ec2.amazonaws.com`)
- **Action**: `sts:AssumeRole`

## Setup Instructions

1. **Initialize Git Repository**
   ```bash
   git init
   git remote add origin <your-repo-url>
   ```

2. **Review IAM Policies**
   - Navigate to `lab01/` folder
   - Review each policy document
   - Understand the permissions and resources

3. **Create IAM Roles**
   - Use the trust policy to create a new role
   - Attach the appropriate policies to the role

4. **Assign Roles**
   - Attach policies to IAM users
   - Assign roles to EC2 instances

5. **Test Permissions**
   - Verify developer access to S3
   - Verify operations read-only access
   - Test EC2 instance role assumption

## Git Commands

### View Repository Status
```bash
git status
```

### Add Changes
```bash
git add .
```

### Commit Changes
```bash
git commit -m "Your commit message"
```

### Push to Remote
```bash
git push -u origin main
```

### View Commit History
```bash
git log --oneline
```

## Files Description

| File | Purpose |
|------|---------|
| `README.md` | Project documentation |
| `menu.txt` | Menu configuration |
| `menu-downloaded.txt` | Downloaded menu items |

## Getting Started

1. Clone this repository
2. Review the IAM policy files
3. Follow the setup instructions
4. Test the configurations

## Contributing

When making changes:
1. Make descriptive commits
2. Push to origin main
3. Document all changes

## License

This is a lab project for AWS training purposes.

---

**Last Updated**: April 10, 2026
**Repository**: https://github.com/firaskhdhir11-lab/lab0.git
