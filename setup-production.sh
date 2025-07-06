#!/bin/bash

# Production Nextcloud Setup Script
echo "🚀 Setting up Production Nextcloud..."

# Check if .env file exists
if [ ! -f .env ]; then
    echo "⚠️  .env file not found. Copying from .env.example..."
    cp .env.example .env
    echo "📝 Please edit .env file with your production values before continuing."
    echo "   Required changes:"
    echo "   - DOMAIN=your-domain.com"
    echo "   - All passwords (make them secure!)"
    echo "   - TRAEFIK_EMAIL=your-email@example.com"
    echo ""
    echo "After editing .env, run this script again."
    exit 1
fi

# Source environment variables
source .env

# Validate required variables
if [ "$DOMAIN" = "your-domain.com" ]; then
    echo "❌ Please update DOMAIN in .env file"
    exit 1
fi

if [ "$ADMIN_PASSWORD" = "your_secure_admin_password_here" ]; then
    echo "❌ Please update ADMIN_PASSWORD in .env file"
    exit 1
fi

echo "✅ Environment configuration validated"

# Update Traefik email in docker-compose.yaml
sed -i "s/your-email@example.com/$TRAEFIK_EMAIL/g" docker-compose.yaml

# Create necessary directories
mkdir -p config logs

# Set proper permissions
echo "🔒 Setting up permissions..."
sudo chown -R www-data:www-data config/ || true

# Pull latest images
echo "📦 Pulling latest images..."
docker-compose pull

# Start services
echo "🏃 Starting services..."
docker-compose up -d

# Wait for services to be ready
echo "⏳ Waiting for services to start..."
sleep 5

# Show status
echo "📊 Service status:"
docker-compose ps

echo ""
echo "🎉 Production Nextcloud setup complete!"
echo ""
echo "📋 Access Information:"
echo "   Nextcloud: https://$DOMAIN"
echo "   Traefik Dashboard: https://traefik.localhost:8080"
echo "   Admin User: $ADMIN_USER"
echo ""
echo "🔧 Next Steps:"
echo "1. Configure DNS to point $DOMAIN to this server"
echo "2. Wait for Let's Encrypt certificate generation (may take a few minutes)"
echo "3. Access Nextcloud and complete the setup wizard"
echo "4. Configure additional security settings in Nextcloud admin panel"
echo ""
echo "📱 To enable background jobs (recommended):"
echo "   Add this to your crontab: */5 * * * * docker exec -u www-data nextcloud-app-1 php /var/www/html/cron.php"
echo ""
echo "🔍 To check logs:"
echo "   docker-compose logs -f"
