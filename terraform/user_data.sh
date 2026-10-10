
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
