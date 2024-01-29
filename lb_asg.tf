# Create an application load balancer
resource "aws_lb" "alb" {
  name               = "application-load-balancer"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.lb_sg.id]
  subnets            = [aws_subnet.public-subnet-1.id, aws_subnet.public-subnet-2.id]
}

# Target group for alb
resource "aws_lb_target_group" "target_group_alb" {
  name     = "target-group-alb"
  port     = var.target_alb_port
  protocol = "HTTPS"
  vpc_id   = aws_vpc.vpc.id
}
# Attach target group to the first instance
resource "aws_lb_target_group_attachment" "attachment1" {
  target_group_arn = aws_lb_target_group.target_group_alb.arn
  target_id        = aws_instance.wordpress1.id
  port             = var.target_alb_port
  depends_on = [aws_instance.wordpress1,]
}
# Attach target group to the second instance
resource "aws_lb_target_group_attachment" "attachment2" {
  target_group_arn = aws_lb_target_group.target_group_alb.arn
  target_id        = aws_instance.wordpress2.id
  port             = var.target_alb_port
  depends_on = [aws_instance.wordpress2,]
}
# Attach target group to alb
resource "aws_lb_listener" "external-lb" {
  load_balancer_arn = aws_lb.alb.arn
  port              = var.target_alb_port
  protocol          = "HTTPS"
  certificate_arn = aws_acm_certificate_validation.default.certificate_arn
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.target_group_alb.arn
  }
}

data "aws_ami" "amazon_linux" {
  #executable_users = ["self"]
  most_recent = true
  name_regex  = "^amzn2*"
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-kernel*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_launch_configuration" "web" {
  name_prefix   = "web-"
  image_id      = data.aws_ami.amazon_linux.id #var.ami
  instance_type = "t2.micro"
  spot_price = "0.001" //for cost optimization
  key_name = aws_key_pair.locally_generated_key.key_name
  security_groups = [aws_security_group.web_sg.id]
  provisioner "remote-exec" {
        #sudo apt install mysql-server
        inline = [
            "sudo apt-get update -y",
            "sudo apt-get install -y apache2 php libapache2-mod-php php-mysql",
            "sudo service apache2 start",
         ]
      
    }

  lifecycle {
    create_before_destroy = true
  }
}
resource "aws_autoscaling_group" "web" {
  name                      = "asg-${aws_launch_configuration.web.name}"
  max_size                  = 4
  min_size                  = 2
  health_check_grace_period = 300
  health_check_type         = "ELB"
  desired_capacity          = 3
  force_delete              = false
  launch_configuration      = aws_launch_configuration.web.name
  vpc_zone_identifier       = [aws_subnet.public-subnet-1.id, aws_subnet.public-subnet-2.id]

 lifecycle {
    create_before_destroy = true
  }
  tag {
    key                 = "Name"
    value               = "${var.project}-EC2 instances launched via this ASG"
    propagate_at_launch = true
  }
}
# Attach ASG to alb target group
resource "aws_autoscaling_attachment" "asg_attachment" {
  autoscaling_group_name = aws_autoscaling_group.web.id
  lb_target_group_arn = aws_lb_target_group.target_group_alb.arn
}