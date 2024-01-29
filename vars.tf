#The project name for tagging related resources
variable project {
  description = "this is name for tags"
}
#Variable Declaration
variable "key_pair_name" {
  type = string
  default  = "awskeypair"
}

#Public key to use in Key pair
variable "public_key" {
  type = string
  default  = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDoh7hDNZ1age8vZgCzJ2eTfWOCNEeO9KD3csS81H1PpPiFy5R778VHLtc7To7pBhUxXLL7lr/UfzNOisA7/R9LYUvDui8kwL4pUTnF9AsfnA+EdimZNeb8QB4LaxiY5bVPOTtshbyw3Exxmz4eEEbGlROslboSvc1F2I1KRmJ5gTlJk/N9AqADCfu55zjqFiwx2VBfx1BA+QQEjVUgKxbtSxXmbIi+B8meF/ocg0TO24GNqJAbA5826z8QxFxqyOBO2x3+zochGPBQWsPg8Rv4F1bRjNrWIu+D1B71HVqlnOPldOfzESANz5ICqk2KK8oZuhNfha6JjN+kmjIf/SU+Bmk9Rn19M+GnPdVUPNgHa0j/8t9WLkUb23zauqsCRMYQtMJsVq7T9mGwEsQodn2fZlW7NFZ8Kza+RRYHRFSQCIONvtjMPuSfet8geokkHFSdg7Rqwv8WSigErBry15eIaVr9l/854n4sXCuvAfcV9vr+KxYc+eT4mj0MbVQtPagQwKJKzvDZNI6O7N4kccmDNnzlDljrllmTmLtHEaMmlYi/AeDHgZKZ/TzPKNUZWpTtcsjPmAI2S/oT8CDS4Pbdw0br3TmvlCLKHINVCnxmU40y1qvehvIeWqDngjEIrugeeCY0I2MqOTsgTZVtBvRCUAO/vnnnbIe0S072whvROw== avi@AyMDevice"
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
  default = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnet_cidrs" {
  type = list(string)
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
variable db_username {
  description = "Enter please the DB username:"
}
variable db_password {
  description = "Enter please the DB password:"
}
variable db_name {
  description = "Enter please the DB name:"
}
variable role_arn {
  description = "Enter please the IAM role ARN:"
}