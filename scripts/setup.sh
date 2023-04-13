#!/bin/bash

# Install necessary packages
sudo apt-get update
sudo apt-get install -y python3-pip python3-dev python3-venv nginx

# Install Flask and Gunicorn
python3 -m venv venv
source venv/bin/activate
pip install gunicorn flask

# Create a systemd service for Gunicorn
sudo touch /etc/systemd/system/helloworld.service
sudo chmod 666 /etc/systemd/system/helloworld.service

sudo cat << EOF > /etc/systemd/system/helloworld.service
[Unit]
Description=Gunicorn instance for a simple hello world app
After=network.target

[Service]
User=ubuntu
Group=www-data
WorkingDirectory=/home/ubuntu/helloworld
ExecStart=/home/ubuntu/helloworld/venv/bin/gunicorn -b localhost:8000 app:app
Restart=always

[Install]
WantedBy=multi-user.target
EOF

# Start and enable the Gunicorn service
sudo systemctl daemon-reload
sudo systemctl start helloworld
sudo systemctl enable helloworld

# Configure Nginx
sudo touch /etc/nginx/sites-available/default
sudo chmod 666 /etc/nginx/sites-available/default

sudo echo "upstream flaskhelloworld {
    server 127.0.0.1:8000;
}
server {
        listen 80 default_server;
        listen [::]:80 default_server;

        root /var/www/html;

		index index.html index.htm index.nginx-debian.html;

        server_name _;

        location / {
                proxy_pass http://flaskhelloworld;
        }
}" > /etc/nginx/sites-available/default

sudo ln -s /etc/nginx/sites-available/myproject /etc/nginx/sites-enabled

# Test Nginx configuration and restart
sudo systemctl restart nginx