#!/bin/bash

# SSL setup script for Nextcloud
# This script will help you obtain SSL certificates using Let's Encrypt

echo "Setting up SSL certificates for nextcloud.upturn.com.bd..."

# Create directories for certbot
mkdir -p certbot/conf
mkdir -p certbot/www

# First, start the containers with HTTP only to get the initial certificate
echo "Starting containers with HTTP configuration..."
docker compose up -d

# Wait for containers to be ready
echo "Waiting for containers to start..."
sleep 5

# Test if the domain is accessible
echo "Testing domain accessibility..."
curl -I http://nextcloud.upturn.com.bd || echo "Warning: Domain not accessible yet. Make sure DNS is configured properly."

# Get the initial certificate
echo "Obtaining SSL certificate..."
docker compose run --rm certbot certonly \
    --webroot \
    --webroot-path=/var/www/certbot \
    --email saim.ul.islam@outlook.com \
    --agree-tos \
    --no-eff-email \
    -d nextcloud.upturn.com.bd

# Check if certificate was obtained successfully
if [ -f "certbot/conf/live/nextcloud.upturn.com.bd/fullchain.pem" ]; then
    echo "SSL certificate obtained successfully!"
    
    # Update nginx configuration to use HTTPS
    echo "Updating nginx configuration for HTTPS..."
    cp nginx-https.conf nginx-simple.conf
    
    # Restart containers with HTTPS configuration
    echo "Restarting containers with HTTPS configuration..."
    docker compose down
    docker compose up -d
    
    echo "Setup complete! Your Nextcloud should now be accessible at https://nextcloud.upturn.com.bd"
    echo "Note: It may take a few minutes for the containers to fully start."
else
    echo "Error: Failed to obtain SSL certificate."
    echo "Please check:"
    echo "1. Your domain nextcloud.upturn.com.bd is pointing to this server"
    echo "2. Port 80 is accessible from the internet"
    echo "3. No firewall is blocking the connection"
fi

# Set up certificate renewal
echo "Setting up certificate auto-renewal..."
cat > renew-certs.sh << 'EOF'
#!/bin/bash
docker compose run --rm certbot renew
docker compose exec web nginx -s reload
EOF

chmod +x renew-certs.sh

echo "Auto-renewal script created: renew-certs.sh"
echo "Add this to your crontab to run monthly:"
echo "0 2 1 * * /path/to/your/nextcloud/renew-certs.sh"
