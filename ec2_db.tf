#Resource to Create Key Pair
resource "aws_key_pair" "locally_generated_key" {
  key_name   = var.key_pair_name
  public_key = var.public_key 
}

#Create a first EC2 using Key Pair
resource "aws_instance" "wordpress1" {
    
	ami = var.ami
	instance_type = var.instance_type
  subnet_id = aws_subnet.public-subnet-1.id
  vpc_security_group_ids = [aws_security_group.web_sg.id]
	key_name = aws_key_pair.locally_generated_key.key_name
  tags = {
        Name = "${var.project}-instance1"
        }
  depends_on = [aws_key_pair.locally_generated_key, aws_db_instance.mysql]

  provisioner "remote-exec" {
        #sudo apt install mysql-server
        inline = [
            "sudo apt-get update -y",
            "sudo apt-get install -y apache2 php libapache2-mod-php php-mysql",
            "sudo service apache2 start",
         ]
      
    }
}
#Create a second EC2 using Key Pair
resource "aws_instance" "wordpress2" {
    
	ami = var.ami
	instance_type = var.instance_type
  subnet_id = aws_subnet.public-subnet-2.id
  vpc_security_group_ids = [aws_security_group.web_sg.id]
	key_name = aws_key_pair.locally_generated_key.key_name

  tags = {
        Name = "${var.project}-instance2"
        }
  depends_on = [aws_key_pair.locally_generated_key, aws_db_instance.mysql]

  provisioner "remote-exec" {
        #sudo apt install mysql-server
        inline = [
            "sudo apt-get update -y",
            "sudo apt-get install -y apache2 php libapache2-mod-php php-mysql",
            "sudo service apache2 start",
         ]
      
    }
}

resource "aws_db_instance" "mysql" {
  identifier              = "mysql-rds-instance"
  allocated_storage       = 10
  db_name                 = var.db_name
  engine                  = "mysql"
  engine_version          = "5.7"
  instance_class          = "db.t2.micro"
  username                = var.db_username
  password                = var.db_password
  backup_retention_period = 7
  multi_az                = false //True for high availability
  availability_zone       = var.az[0]
  db_subnet_group_name    = aws_db_subnet_group.db_subnet_group.id
  skip_final_snapshot     = true
  vpc_security_group_ids  = [aws_security_group.database-sg.id]
  storage_encrypted       = true //for security
  tags = {
    Name = "${var.project}-mysql-rds-instance"
  }
}
resource "aws_db_instance" "mysql_replica" {
  replicate_source_db    = aws_db_instance.mysql.identifier
  instance_class         = "db.t2.micro"
  identifier             = "replica-mysql-instance"
  allocated_storage      = 10
  skip_final_snapshot    = true
  multi_az               = false
  availability_zone      = var.az[1]
  vpc_security_group_ids = [aws_security_group.database-sg.id]
  storage_encrypted      = true
  tags = {
    Name = "${var.project}-mysql-rds-replica"
  }
}