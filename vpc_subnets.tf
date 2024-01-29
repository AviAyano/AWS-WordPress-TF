resource "aws_vpc" "vpc" {
    cidr_block = var.vpc_cidr

    tags = {
    Name = "${var.project}-vpc"
  }
}
resource "aws_subnet" "public-subnet-1" {
    vpc_id = aws_vpc.vpc.id
    cidr_block = var.public_subnet_cidrs[0]
    availability_zone = var.az[0]

    tags = {
    Name = "${var.project}-public-subnet-1"
  }
}
resource "aws_subnet" "public-subnet-2" {
    vpc_id = aws_vpc.vpc.id
    cidr_block = var.public_subnet_cidrs[1]
    availability_zone = var.az[1]

    tags = {
    Name = "${var.project}-public-subnet-1"
  }
}
resource "aws_subnet" "private-subnet-1" {
    vpc_id = aws_vpc.vpc.id
    cidr_block = var.public_subnet_cidrs[0]
    availability_zone = var.az[0]

    tags = {
    Name = "${var.project}-private-subnet-1"
  }
}
resource "aws_subnet" "private-subnet-2" {
    vpc_id = aws_vpc.vpc.id
    cidr_block = var.public_subnet_cidrs[1]
    availability_zone = var.az[1]

    tags = {
    Name = "${var.project}-private-subnet-2"
  }
}
resource "aws_db_subnet_group" "db_subnet_group" {
    name = "db_subnet_group"
    subnet_ids = [aws_subnet.private-subnet-1.id,aws_subnet.private-subnet-2.id]
}
#For dynamic blocks if you have many subnets (>4)

# resource "aws_subnet" "public_subnets" {
#  count      = length(var.public_subnet_cidrs)
#  vpc_id     = aws_vpc.vpc.id
#  cidr_block = element(var.public_subnet_cidrs, count.index)
 
#  tags = {
#    Name = "${var.project}-Public Subnet ${count.index + 1}"
#  }
# }
 
# resource "aws_subnet" "private_subnets" {
#  count      = length(var.private_subnet_cidrs)
#  vpc_id     = aws_vpc.vpc.id
#  cidr_block = element(var.private_subnet_cidrs, count.index)
 
#  tags = {
#    Name = "${var.project}-Private Subnet ${count.index + 1}"
#  }
# }