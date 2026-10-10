
resource "aws_instance" "web" {
  for_each = toset(var.deployments)

  ami                         = var.ami_id
  instance_type               = var.instance_type
  key_name                    = var.key_pair
  subnet_id                   = aws_subnet.public.id
  vpc_security_group_ids      = [aws_security_group.web.id]
  associate_public_ip_address = true

  user_data = <<-EOF
#!/bin/bash
set -euxo pipefail

exec > /var/log/user-data.log 2>&1

export DEBIAN_FRONTEND=noninteractive

apt-get update -y
apt-get install -y docker.io

systemctl enable --now docker

docker pull ghcr.io/ashiqomar/devops_project:latest

docker run -d \
  --name simple-devops \
  --restart unless-stopped \
  -p 80:80 \
  ghcr.io/ashiqomar/devops_project:latest
EOF

  tags = {
    Name       = each.key == "deployment-001" ? "devops-ec2" : "devops-ec2-${each.key}"
    Deployment = each.key
    team       = "demo-sjce"
  }

  lifecycle {
    ignore_changes = [user_data]
  }
}