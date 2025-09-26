#!/bin/bash
# Update and install nginx
apt update -y
apt install -y nginx

# Enable and start nginx
systemctl start nginx
systemctl enable nginx

# Custom index page
echo "<h1>Welcome to Terraform NTI Course Server</h1>" > /var/www/html/index.html
