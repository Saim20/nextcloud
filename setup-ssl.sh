#!/bin/bash

# Nextcloud Let's Encrypt Setup Script
# This script will set up SSL certificates for your Nextcloud instance

DOMAIN="nextcloud.upturn.com.bd"
EMAIL="saim.ul.islam@outlook.com"

echo "🚀 Starting Nextcloud SSL setup for $DOMAIN"

# Check if docker compose is available
if ! command -v docker &> /dev/null; then
    echo "❌ docker not found. Please install Docker first."
    exit 1
fi

if ! docker compose version &> /dev/null; then
    echo "❌ docker compose not available. Please install Docker Compose plugin."
    exit 1
fi

# Step 1: Generate DH parameters (this might take a while)
echo "🔐 Generating DH parameters (this may take 5-10 minutes)..."
if [ ! -f "./dhparam.pem" ]; then
    docker run --rm -v $(pwd):/output alpine/openssl dhparam -out /output/dhparam.pem 2048
    echo "✅ DH parameters generated"
else
    echo "✅ DH parameters already exist"
fi

# Step 2: Start services without SSL first
echo "🐳 Starting services for initial certificate generation..."
docker compose up -d db nextcloud

# Wait for services to be ready
echo "⏳ Waiting for services to start..."
sleep 30

# Step 3: Start nginx for HTTP challenge
echo "🌐 Starting Nginx for certificate challenge..."
docker compose up -d nginx

# Wait for nginx to be ready
sleep 10

# Step 4: Generate initial certificate
echo "🔒 Generating Let's Encrypt certificate..."
docker compose run --rm certbot \
    certbot certonly \
    --webroot \
    --webroot-path=/var/www/certbot \
    --email $EMAIL \
    --agree-tos \
    --no-eff-email \
    -d $DOMAIN

if [ $? -eq 0 ]; then
    echo "✅ Certificate generated successfully!"
    
    # Step 5: Copy DH parameters to the correct location
    echo "📋 Setting up DH parameters..."
    docker compose exec nginx mkdir -p /etc/ssl/certs
    docker compose exec nginx sh -c "cat > /etc/ssl/certs/dhparam.pem" < ./dhparam.pem
    
    # Step 6: Restart nginx to enable SSL
    echo "🔄 Restarting Nginx with SSL enabled..."
    docker compose restart nginx
    
    # Step 7: Start certbot for auto-renewal
    echo "🔄 Starting Certbot for auto-renewal..."
    docker compose up -d certbot
    
    echo ""
    echo "🎉 SSL setup completed successfully!"
    echo "Your Nextcloud instance should now be available at: https://$DOMAIN"
    echo ""
    echo "📋 Next steps:"
    echo "1. Make sure your DNS points $DOMAIN to this server's IP"
    echo "2. Check that ports 80 and 443 are open in your firewall"
    echo "3. Access your Nextcloud at https://$DOMAIN"
    echo "4. Default admin credentials: admin / admin123 (change these!)"
    echo ""
    echo "🔧 Useful commands:"
    echo "- View logs: docker compose logs -f"
    echo "- Check certificate: docker compose exec nginx openssl x509 -in /etc/letsencrypt/live/$DOMAIN/fullchain.pem -text -noout"
    echo "- Renew certificate manually: docker compose exec certbot certbot renew"
    
else
    echo "❌ Certificate generation failed!"
    echo "Please check:"
    echo "1. DNS is pointing $DOMAIN to this server"
    echo "2. Port 80 is accessible from the internet"
    echo "3. No other services are using port 80"
    echo ""
    echo "You can check the logs with: docker compose logs nginx certbot"
fi
