
# Deploying Wordpress App on AWS with RDS using Terraform
(./wordpress_architecture.png)


intro:
=========
This repository contains AWS infrastructure for WordPress using terraform to provision infrastructure. 
The tf Code creates following aws services.

1. VPC and it's components [Subnets, Route Tables, Internet Gateway, Nat Gateway etc]
2. EC2 instances 
3. EIP for each of NAT Gateways (there is two for high-availability)
4. Security Groups to access both EC2 and MYSQL
5. RDS mysql instance
6. Application load balancer and target group
7. Auto scaling group and launch configuration
8. Route53 with SSL
9. S3 and dynamodb for remote store for terraform state
Note:  
-----
You may get charged by aws for using services

The Four Benefits of using AWS architecture for WordPress:
======================================================
1.Security: 
Security is a top priority on AWS. AWS Identity and Access Management (IAM) allows you to control access to resources, implement encryption, and use various security tools to protect your WordPress site.

2.High Availability and Reliability: 
Multiple availability zones and redundancy ensure high availability and minimal downtime on AWS. You can enhance reliability and data redundancy by using Amazon RDS (Relational Database Service) for the WordPress database and Amazon S3 for the media storage.

3.Cost-Effectiveness: 
AWS provides a pay-as-you-go model, allowing you to pay for the resources you use without any long-term commitments. As a result, you can optimize costs based on the requirements of your site.

4.Scalability: 
You can scale AWS resources up or down based on traffic spikes or changing demands. By using services such as Amazon EC2 and Auto Scaling, you can easily increase server capacity without compromising site performance.

### Pre-requisite:

   1. You need to have SSh keys generated , there is a coupe of ways to do that .
   ( Linux: https://cloudkatha.com/how-to-create-key-pair-in-aws-using-terraform-in-right-way/
     Windows: https://letmetechyou.com/create-an-aws-key-pair-using-terraform/  )

   2. Create an IAM Role for terraform access and create security credentials using aws console (AccessKey, SecretKey) and update in the `~/.aws/credentials`.
   
   __Note__ : If you have default profile, just erase the `profile` attribute in `provider.tf`


Usage:
=======

provisioning:
-------------

1. git clone https://github.com/AviAyano/Wordpress-on-AWS-using-TF.git
2. cd Wordpress-on-AWS-using-TF
- Run `terraform init`
- Run `terraform plan`
- Run `terraform apply`


## Structure
This repository provides the minimal set of resources, which may be required for starting comfortably developing the process of new IaC project:

  ec2_bd.tf - AWS EC2 and RDS MySQL DataBase and RDS replica

  lb_asg.tf - AWS Application Load Balancer and AWS Auto Scaling Group (ASG) 

  security_group.tf - security groups for all instances

  output.tf - Terraform Output Values

  network.tf - AWS Route53, route_table, Nat gateways, elstic IP, internet gateway

  security_group.tf - AWS EC2-VPC Security Group Terraform module

  vpc_subnets.tf - AWS VPC and public/privte subnets

  vars.tf - variables used in Terraform. 

  __Note__ : Customize the terraform code for your project needs !!!


Destroying the Infra:
---------------------
Run the next commands to destroy all WordPress project:

1.cd Wordpress-on-AWS-using-TF folder (Be in the repo directory)

2. copy it and run
```bash
terraform destroy -auto-approve
```
