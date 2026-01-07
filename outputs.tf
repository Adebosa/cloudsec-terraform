output "vpc_id" {
  value = aws_vpc.this.id
}

output "ec2_private_ip" {
  value = aws_instance.compute.private_ip
}

output "db_endpoint" {
  value = aws_db_instance.database.endpoint
}
