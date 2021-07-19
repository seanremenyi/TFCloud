provider "aws" {
  region = "ap-southeast-2"
}

resource "aws_instance" "web" {
  ami             = "ami-04f77aa5970939148"
  instance_type   = "t3.micro"

  tags = {
    Name = "Challenge1"
  }
}
