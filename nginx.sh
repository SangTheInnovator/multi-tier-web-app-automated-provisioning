# Install nginx server
apt update && apt install nginx -y

# Create nginx config gile
cat <<EOT > profile_app
upstream profile_app {
    server app01:8080
}

server {
    listen 80;

location / {
    proxy_pass http://profile_app
}

}
EOT

mv profile_app /etc/nginx/sites-available/profile_app

# Remove default nginx configuration
rm -rf /etc/nginx/sites-enabled/default

# Create link to activate website
ln -s /etc/nginx/sites-available/profile_app /etc/nginx/sites-enabled/profile_app

# Start nginx service and firewall
systemctl start nginx
systemctl enable nginx
systemctl restart nginx