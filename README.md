# Cloud Security Terraform Take-Home

## Overview
This project provisions a simple, secure AWS environment using Terraform.  
It includes compute infrastructure and a datastore that can communicate securely, with a strong emphasis on cloud security best practices.

The goal was to keep the design realistic, minimal, and easy to understand while demonstrating sound security decision-making.

---

## Architecture Summary
- A dedicated VPC with private networking
- EC2 instance deployed in a private subnet
- RDS database restricted to application access only
- IAM role-based access (no static credentials)
- Encryption enabled for data at rest

---

## Security Design Decisions

### Private Networking
All resources are deployed into private subnets with no public IPs. This minimizes external exposure and reduces the attack surface.

### Security Groups
Security groups are tightly scoped:
- The compute instance allows outbound traffic only
- The database allows inbound traffic **only** from the compute security group

This ensures least-privilege network access.

### IAM Best Practices
The EC2 instance uses an IAM role rather than static access keys. This follows AWS security best practices and avoids credential leakage.

### Encryption
The database uses encryption at rest by default to protect sensitive data.

---

## Terraform Structure
The Terraform code is split by responsibility:
- `network.tf` handles networking
- `security.tf` defines security controls
- `compute.tf` provisions application compute
- `datastore.tf` provisions persistent storage

This structure improves readability, auditing, and future scalability.

---

## Notes on Secrets
For simplicity, the database password is defined directly in Terraform.  
In a production environment, this would be replaced with AWS Secrets Manager or Parameter Store.

---

## Future Improvements
- Use Secrets Manager for credentials
- Add VPC endpoints for private AWS service access
- Enable multi-AZ for RDS
- Integrate security scanning tools like tfsec or Checkov
- Add CloudWatch monitoring and alarms

---

## Conclusion
This project demonstrates a security-first approach to infrastructure-as-code, focusing on least privilege, reduced attack surface, and clear documentation.
