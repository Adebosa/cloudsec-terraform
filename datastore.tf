resource "aws_db_subnet_group" "db_subnet" {
  name       = "db-subnet-group"
  subnet_ids = [aws_subnet.private.id]
}

resource "aws_db_instance" "database" {
  identifier             = "cloudsec-db"
  engine                 = "mysql"
  instance_class         = "db.t3.micro"
  allocated_storage      = 20
  username               = "adminuser"
  password               = "ChangeMe123!"   # Explained in README
  db_subnet_group_name   = aws_db_subnet_group.db_subnet.name
  vpc_security_group_ids = [aws_security_group.db_sg.id]
  publicly_accessible    = false
  storage_encrypted      = true
  skip_final_snapshot    = true
}
