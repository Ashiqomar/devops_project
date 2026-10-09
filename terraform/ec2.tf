
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "devops-igw"
  }
}
resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true

  tags = {
    Name = "devops-public-subnet"
  }
}
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = {
    Name = "devops-public-route-table"
  }
}
resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}
resource "aws_instance" "web" {
  ami           = "ami-0d27e0fb3bac4d724"
  instance_type = "t3.micro"
  key_name      = "demo"

  subnet_id = aws_subnet.public.id

  vpc_security_group_ids = [
    aws_security_group.web.id
  ]

  user_data = <<-EOF
              #!/bin/bash

              yum update -y
              yum install -y docker

              systemctl enable docker
              systemctl start docker

              usermod -aG docker ec2-user

              sleep 10

              docker pull ghcr.io/ashiqomar/devops_project:latest

              docker run -d \
                --name simple-devops \
                --restart unless-stopped \
                -p 80:80 \
                ghcr.io/ashiqomar/devops_project:latest
              EOF

  tags = {
    Name = "devops-ec2"
  }
}