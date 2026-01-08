data "aws_ssm_parameter" "al2023_ami" {
  name = "/aws/service/ami-amazon-linux-latest/al2023-ami-kernel-6.1-x86_64"
}

resource "aws_iam_role" "ec2_role" {
  name = "ec2-cloudsec-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect    = "Allow"
      Principal = { Service = "ec2.amazonaws.com" }
      Action    = "sts:AssumeRole"
    }]
  })
}

# Optional but recommended: enable SSM so you can manage the instance without SSH
resource "aws_iam_role_policy_attachment" "ssm_managed_instance" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_instance_profile" "ec2_profile" {
  name = "ec2-cloudsec-profile"
  role = aws_iam_role.ec2_role.name
}

resource "aws_instance" "compute" {
  ami                         = data.aws_ssm_parameter.al2023_ami.value
  instance_type               = var.instance_type
  subnet_id                   = aws_subnet.private.id
  vpc_security_group_ids      = [aws_security_group.compute_sg.id]
  associate_public_ip_address = false
  iam_instance_profile        = aws_iam_instance_profile.ec2_profile.name

  # Security best practice: enforce IMDSv2
  metadata_options {
    http_tokens = "required"
  }

  # Explicit encryption (good for security reviews)
  root_block_device {
    encrypted = true
    volume_type = "gp3"
    volume_size = 10
  }

  tags = {
    Name = "secure-compute"
  }
}
