#!/bin/bash

# Nextcloud SSL Management Script

case "$1" in
    "renew")
        echo "🔄 Renewing SSL certificate..."
        docker compose exec certbot certbot renew
        docker compose restart nginx
        echo "✅ Certificate renewal completed"
        ;;
    "status")
        echo "📋 SSL Certificate Status:"
        docker compose exec nginx openssl x509 -in /etc/letsencrypt/live/nextcloud.upturn.com.bd/fullchain.pem -text -noout | grep -A2 "Validity"
        ;;
    "logs")
        echo "📝 Viewing logs..."
        docker compose logs -f nginx certbot
        ;;
    "restart")
        echo "🔄 Restarting services..."
        docker compose restart nginx nextcloud
        echo "✅ Services restarted"
        ;;
    *)
        echo "Nextcloud SSL Management"
        echo "Usage: $0 {renew|status|logs|restart}"
        echo ""
        echo "Commands:"
        echo "  renew   - Renew SSL certificate"
        echo "  status  - Check certificate expiry"
        echo "  logs    - View nginx and certbot logs"
        echo "  restart - Restart nginx and nextcloud services"
        ;;
esac
