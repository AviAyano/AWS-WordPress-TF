output "wordpress1_public_ip" {
  description = "The wordpress1 public ip value:"
  value = aws_instance.wordpress1.public_ip
}
output "wordpress2_public_ip" {
  description = "The wordpress2 public ip value:"
  value = aws_instance.wordpress2.public_ip
}
output "rds_endpoint" {
  description = "The rds endpoint MySQL value:"  
  value = aws_db_instance.mysql.endpoint
}
output "rds_endpoint_replica" {
  description = "The rds endpoint replica value:"
  value = aws_db_instance.mysql_replica.endpoint
}
# print the DNS of load balancer
output "lb_dns_name" {
  description = "The DNS name of the load balancer:"
  value       = aws_lb.alb.dns_name
}