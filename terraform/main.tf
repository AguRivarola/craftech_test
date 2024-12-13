provider "aws" {
  region = "us-east-1"
}

resource "random_string" "suffix" {
  length  = 6
  special = false
  upper   = false
}

# Security Group
resource "aws_security_group" "instance_sg" {
  name_prefix = "devops-sg"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8000
    to_port     = 8000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }


  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# IAM Role for EC2 Instance
resource "aws_iam_role" "ec2_role" {
  name = "ec2-instance-role-${random_string.suffix.result}"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "ec2.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })
}

# IAM Policy to Allow ECR Access
resource "aws_iam_policy" "ecr_policy" {
  name        = "ecr-access-policy-${random_string.suffix.result}"
  description = "Policy to allow EC2 to access ECR"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "ecr:GetAuthorizationToken",
          "ecr:BatchCheckLayerAvailability",
          "ecr:GetDownloadUrlForLayer",
          "ecr:BatchGetImage",
          "ecr:ListImages"
        ],
        Resource = "*"
      }
    ]
  })
}

# Attach Policy to IAM Role
resource "aws_iam_role_policy_attachment" "ec2_role_policy" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = aws_iam_policy.ecr_policy.arn
}

# Instance Profile for EC2
resource "aws_iam_instance_profile" "ec2_instance_profile" {
  name = "ec2-instance-profile-${random_string.suffix.result}"
  role = aws_iam_role.ec2_role.name
}

# EC2 Instance
resource "aws_instance" "devops_ec2" {
  ami           = "ami-005fc0f236362e99f"
  instance_type = var.instance_type
  key_name      = var.key_pair_name

  vpc_security_group_ids = [aws_security_group.instance_sg.id]

  iam_instance_profile = aws_iam_instance_profile.ec2_instance_profile.name

  user_data = file("../deploy.sh")

  root_block_device {
    volume_size = 30
    volume_type = "gp3"
  }

  tags = {
    Name = "DevOps-EC2"
  }
}
