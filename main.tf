provider "aws" {
  region = "ap-southeast-2" 
}

resource "aws_security_group" "ec2_security_group" {
  description = "Allow SSH and HTTP traffic"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  
  }

  ingress {
    from_port   = 8080
    to_port     = 8080
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



resource "aws_instance" "my_ec2" {
  ami           = "ami-040e71e7b8391cae4"  
  instance_type = "t2.micro"               
  key_name      = "jenkins"

  tags = {
    Name = "MyFirstEC2"  
  }
  user_data = file("docker_install.sh")
}

output "public_ip" {
  value = aws_instance.my_ec2.public_ip
}
