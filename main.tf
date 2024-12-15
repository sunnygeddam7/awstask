provider "aws" {
  region = "ap-southeast-2" 
}

resource "aws_security_group" "ec2_security_group" {
  name        = "ec2_security_group"
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
  security_groups = [aws_security_group.ec2_security_group.name] 

  tags = {
    Name = "MyFirstEC2"  
  }

  user_data = <<-EOF
  #!/bin/bash
  # Update the package list and install prerequisites
  sudo apt-get update -y
  sudo apt-get install -y ca-certificates curl

  # Create the keyrings directory
  sudo install -m 0755 -d /etc/apt/keyrings

  # Add Docker's official GPG key
  sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
  sudo chmod a+r /etc/apt/keyrings/docker.asc

  # Add Docker repository to sources
  echo "deb [arch=\$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \$(. /etc/os-release && echo \"\$VERSION_CODENAME\") stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

  # Update package list and install Docker
  sudo apt-get update -y
  sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

  # Enable and start Docker service
  sudo systemctl enable docker
  sudo systemctl start docker

  # Add 'ubuntu' user to the docker group
  sudo usermod -aG docker ubuntu

  # Output Docker version
  docker --version
EOF
}
