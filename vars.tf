
#Variable Declaration
variable "key_pair_name" {
  type = string
  default  = "awskeypair"
}

variable "instance_type" {
  type    = string
  default = "t2.micro"
}

variable "ami" {
  type    = string
  default = "ami-0a3c3a20c09d6f377"
}
variable "myIP" {
  type = string
  default = "185.175.34.202/32"
}
variable "vpc_cidr" {
  type = string
  default = "10.0.0.0/16"
}

variable "public_subnet_cidrs" {
  type = list(string)
  description = "Public subnet CIDR values"
  default = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnet_cidrs" {
  type = list(string)
  description = "Private subnet CIDR values"
  default = ["10.0.3.0/24", "10.0.4.0/24"]
}
variable "target_alb_port" {
  type    = string
  default = "443"#"80"
}
#Availability-zone for subnets-list of allowed location
variable "az" {
    type = list(string)
    default =["us-east-1a", "us-east-1b"]
    description = "Availability zone for subnets"
  
}
#terraform plan -var-file="./wordpress.tfvars"

#The project name for tagging related resources
variable project {
  description = "Please enter your project name for resource tagging:"
}
#Public key to use in Key pair
variable "public_key" {
  type = string
  description = "Please enter your public key:" 
}
variable db_username {
  type = string
  description = "Please enter the DB username:"
}
variable db_password {
  type = string
  description = "Please enter the DB password:"
}
variable db_name {
  type = string
  description = "Please enter the DB name:"
}
variable role_arn {
  type = string
  description = "Please enter the IAM role ARN:"
}