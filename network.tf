#internet gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "${var.project}-igw"
  }
}

#elastic ip
resource "aws_eip" "eip" {
  domain = "vpc"
  depends_on = [ aws_internet_gateway.igw ]
  tags = {
    Name = "${var.project}-eip"
  }

}

#First nat gateway
resource "aws_nat_gateway" "nat1" {
  allocation_id = aws_eip.eip.id
  subnet_id     = aws_subnet.public-subnet-1.id

  tags = {
    Name = "${var.project}-nat"
  }
}

#Second nat gateway for for high-availability
resource "aws_nat_gateway" "nat2" {
  allocation_id = aws_eip.eip.id
  subnet_id     = aws_subnet.public-subnet-2.id

  tags = {
    Name = "${var.project}-nat2"
  }
}

#public route table
resource "aws_route_table" "public-rt" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "${var.project}-public-rt"
  }
}

#First private route table
resource "aws_route_table" "private-rt-1" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat1.id
  }

  tags = {
    Name = "${var.project}-private-rt-1"
  }
}

#Second private route table
resource "aws_route_table" "private-rt-2" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat2.id
  }

  tags = {
    Name = "${var.project}-private-rt-2"
  }
}
#route table association
resource "aws_route_table_association" "public-subnet-1" {
  subnet_id      = aws_subnet.public-subnet-1.id
  route_table_id = aws_route_table.public-rt.id
}
resource "aws_route_table_association" "public-subnet-2" {
  subnet_id      = aws_subnet.public-subnet-2.id
  route_table_id = aws_route_table.public-rt.id
}
resource "aws_route_table_association" "private-subnet-1" {
  subnet_id      = aws_subnet.private-subnet-1.id
  route_table_id = aws_route_table.private-rt-1.id
}
resource "aws_route_table_association" "private-subnet-2" {
  subnet_id      = aws_subnet.private-subnet-2.id
  route_table_id = aws_route_table.private-rt-2.id
}

resource "aws_acm_certificate" "cert" {
  domain_name       = "demo-web-app.com"
  validation_method = "DNS"
  subject_alternative_names = ["*.demo-web-app.com"]
  tags = {
    Environment = "test"
  }

  lifecycle {
    create_before_destroy = true
  }
}
resource "aws_acm_certificate_validation" "default" {
  certificate_arn = aws_acm_certificate.cert.arn
  validation_record_fqdns =  aws_route53_record.www.records #[for record in aws_route53_record.www : record.fqdn]
}
resource "aws_route53_zone" "primary" {
  name = "demo-web-app.com"
  vpc {
    vpc_id = aws_vpc.vpc.id
    vpc_region = "us-east-1"
  }
  tags = {
    Name = "${var.project}-route53"
  }
}
resource "aws_route53_record" "www" {
  zone_id = aws_route53_zone.primary.zone_id
  name    = aws_acm_certificate.cert.domain_name #"www.demo-web-app.com"
  type    = "A"
  ttl     = 3600
  records = [aws_eip.eip.public_ip]
}