# Multi-Region Disaster Recovery Project

## Overview
This project demonstrates a **three-tier architecture** deployed across multiple AWS regions for disaster recovery (DR) purposes. The architecture includes:

- **Web Tier:** Public-facing web servers behind an Application Load Balancer (ALB)  
- **App Tier:** Private application servers  
- **DB Tier:** MySQL RDS instance with a cross-region read replica  

The project ensures high availability and disaster recovery using AWS services like **S3 cross-region replication**, **RDS read replicas**, and **CloudWatch monitoring**.

---

## Architecture

### VPC & Networking
- **Primary VPC** with public and private subnets across 2 availability zones (AZs)  
- **Public subnets:** Host the web tier and NAT gateways  
- **Private subnets:** Host the app and database tiers  
- **Route tables:**  
  - Public subnets route internet traffic through Internet Gateway  
  - Private app subnets route outbound traffic via NAT gateways  
  - Private DB subnets have no NAT (internal-only access)

### Security Groups
- **Web SG:** Allows HTTP/HTTPS traffic from the internet  
- **App SG:** Allows HTTP traffic only from the web tier  
- **DB SG:** Allows MySQL traffic only from the app tier  

### Web Tier
- **Launch Template** for EC2 instances  
- **Auto Scaling Group** with min 1 and max 2 instances  
- **Application Load Balancer (ALB)** for distributing incoming traffic  
- **ALB Target Group:** Registers web instances  

### App Tier
- EC2 instances in private subnets  
- Receives traffic only from the web tier  

### Database Tier
- **Primary RDS (MySQL)** in private subnet with Multi-AZ for high availability  
- **Read Replica** in secondary region for disaster recovery  
- Automated backups enabled for replication  

### S3 Cross-Region Replication
- **Primary bucket:** Stores web-tier and application code  
- **Secondary bucket:** Receives replicated data from primary  
- Versioning enabled on both buckets  
- IAM role with proper replication permissions  

### Monitoring & Alerts
- **CloudWatch metric alarms** for S3 replication failures  
- **SNS topic** configured to send alerts to `vimalgrm@gmail.com`  

---

## Project Structure
