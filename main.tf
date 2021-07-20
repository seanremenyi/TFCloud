provider "aws" {
  region = "ap-southeast-2"
}

variable "ingresssrules" {
  type    = list(number)
  default = [22, 80, 443]
}

variable "egressrules" {
  type    = list(number)
  default = [80, 443]
}

variable "enable_instance" {
  default = true
}
variable "enable_sg" {
  default = true
}
resource "aws_instance" "web" {
  count           = var.enable_instance ? 1 : 0
  ami             = "ami-04f77aa5970939148"
  instance_type   = "t3.micro"
  security_groups = [aws_security_group.webtraffic[0].name]
  user_data       = file("server-script.sh")

  tags = {
    Name = "Test1"
  }
}

resource "aws_security_group" "webtraffic" {
  name  = "Allow HTTPS"
  count = var.enable_sg ? 1 : 0
  dynamic "ingress" {
    iterator = port
    for_each = var.ingresssrules
    content {
      from_port   = port.value
      to_port     = port.value
      protocol    = "TCP"
      cidr_blocks = ["0.0.0.0/0"]
    }

  }

  dynamic "egress" {
    iterator = port
    for_each = var.egressrules
    content {
      from_port   = port.value
      to_port     = port.value
      protocol    = "TCP"
      cidr_blocks = ["0.0.0.0/0"]
    }

  }
}

output "PublicIP" {
  value = aws_instance.web[0].public_ip
}