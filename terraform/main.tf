# Provider
provider "aws" {
  region = "us-east-1"
}

# Data source for AMI id
data "aws_ami" "latest_amazon_linux" {
  owners      = ["amazon"]
  most_recent = true
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

# EC2 instance
resource "aws_instance" "ec2" {
  count                = 3
  ami                  = data.aws_ami.latest_amazon_linux.id
  subnet_id            = aws_default_subnet.default_subnet.id
  instance_type        = "t3.medium"
  iam_instance_profile = "LabInstanceProfile"
  key_name             = aws_key_pair.key_pair.key_name
  security_groups      = [aws_security_group.sg.id]
  tags = {
    Name = "ec2-ansible-${count.index + 1}"
  }
}

# Default subnet
resource "aws_default_subnet" "default_subnet" {
  availability_zone = "us-east-1a"
}

# SSH key pair 
resource "aws_key_pair" "key_pair" {
  key_name   = "id_rsa"
  public_key = file("/home/ec2-user/.ssh/id_rsa.pub")
}

# Security Group
resource "aws_security_group" "sg" {
  ingress {
    description      = "HTTP from everywhere"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    description      = "HTTPS from everywhere"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    description      = "SSH from everywhere"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "sg-ansible"
  }
}