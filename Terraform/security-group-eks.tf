resource "aws_security_group" "TerraformEC2_Security" {
  name        = "TerraformEC2_Security"
  description = "Allow TLS and http inbound traffic"
  vpc_id      = aws_vpc.main.id

  ingress {
    description      = "Inbound rules"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = [aws_vpc.main.cidr_block]
  }

  ingress {
    description      = "Inbound rules"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = [aws_vpc.main.cidr_block]
  }

  ingress {
    description      = "Inbound rules"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = [aws_vpc.main.cidr_block]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "TerraformEC2_Security"
    instance_name ="Terraform_EC2"
  }
}