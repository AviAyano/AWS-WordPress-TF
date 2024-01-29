# Create security group for load balancer  
resource "aws_security_group" "lb_sg" {
  name        = "lb_sg"
  description = "Allow HTTP traffic"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    description      = "Allow HTTP from anywhere"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }
  
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }
}
# Create security group for web servers
resource "aws_security_group" "web_sg" {
  vpc_id      = aws_vpc.vpc.id
  name        = "web_sg"
  description = "Allow SSH/HTTP.S inbound traffic"
  
# SSH access from anywhere
  ingress {
    description = "Allow SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.myIP]
  }
# HTTP access from anywhere
  ingress {
    description = "Allow HTTP"
    protocol    = "tcp"
    from_port   = 80
    to_port     = 80
    cidr_blocks = ["0.0.0.0/0"]
    security_groups = [aws_security_group.lb_sg.id]
  }
# HTTPS access from anywhere
  ingress {
    description = "Allow HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    security_groups = [aws_security_group.lb_sg.id]
  }
# Internet access to anywhere
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "${var.project}-security_group"
  }
}
# Create a sg for database to allow traffic on port 3306 and from ec2 sg's
resource "aws_security_group" "database-sg" {
  name        = "database-sg"
  description = "sg for database to allow traffic on port 3306 and from ec2 security group's"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    description     = "Allow traffic from port 3306 and from ec2 security group's"
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.web_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }
}