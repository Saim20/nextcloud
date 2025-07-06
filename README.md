# Nextcloud IPv6/IPv4 Dual-Stack Setup

This setup provides a Nextcloud instance that works with both IPv6 globally and IPv4 locally using Docker Compose.

## Architecture

- **Database (MariaDB)**: Handles data persistence
- **App (Nextcloud FPM)**: Core Nextcloud application
- **Web (Nginx)**: Reverse proxy handling both IPv4 and IPv6 traffic

## Network Configuration

- **IPv4 Subnet**: `192.168.0.0/24` (for local communication)
- **IPv6 Subnet**: `2401:f40:1215:b9d::/64` (for global communication)

### IP Address Assignments

| Service | IPv4 Address | IPv6 Address |
|---------|--------------|--------------|
| Database | 192.168.0.200 | 2401:f40:1215:b9d::200 |
| App | 192.168.0.201 | 2401:f40:1215:b9d::201 |
| Web | 192.168.0.202 | 2401:f40:1215:b9d::202 |

> **Note**: The IPv4 addresses are chosen to avoid conflict with your device's IP (192.168.0.102)

## Prerequisites

1. **Docker** and **Docker Compose** installed
2. **IPv6 connectivity** on your host system
3. **Root/sudo access** for Docker daemon configuration

## Setup Instructions

### 1. Configure Docker for IPv6

Run the included setup script to configure Docker daemon for IPv6:

```bash
./setup-docker-ipv6.sh
```

Alternatively, manually configure Docker daemon by editing `/etc/docker/daemon.json`:

```json
{
  "ipv6": true,
  "fixed-cidr-v6": "2401:f40:1215:b9d::/64",
  "experimental": false,
  "ip6tables": true
}
```

Then restart Docker:
```bash
sudo systemctl restart docker
```

### 2. Update Configuration (if needed)

If you need to use a different IPv6 subnet, update the following files:
- `docker-compose.yaml`: Update the IPv6 subnet and addresses
- `setup-docker-ipv6.sh`: Update the fixed-cidr-v6 value

### 3. Start the Services

```bash
docker-compose up -d
```

### 4. Access Nextcloud

- **IPv4 (Local)**: http://localhost or http://192.168.0.103
- **IPv6 (Global)**: http://[your-server-ipv6-address]

## Security Considerations

### Current Setup
- HTTP only (port 80)
- Default database passwords (⚠️ **Change these in production!**)

### For Production Use

1. **Enable HTTPS**:
   - Uncomment SSL configuration in `nginx.conf`
   - Add SSL certificates
   - Update port bindings

2. **Change Database Passwords**:
   - Update `MYSQL_ROOT_PASSWORD` and `MYSQL_PASSWORD` in `docker-compose.yaml`
   - Use environment files or Docker secrets

3. **Configure Firewall**:
   - Allow only necessary ports
   - Consider restricting IPv6 access if not needed globally

## Troubleshooting

### IPv6 Not Working

1. **Check Docker IPv6 support**:
   ```bash
   docker network ls
   docker network inspect nextcloud_nextcloud_network
   ```

2. **Verify host IPv6 connectivity**:
   ```bash
   ping6 google.com
   ```

3. **Check container IPv6 addresses**:
   ```bash
   docker inspect nextcloud_web_1 | grep -i ipv6
   ```

### Port Conflicts

If you get port binding errors:
1. Check what's using ports 80/443:
   ```bash
   sudo netstat -tulpn | grep -E ':80|:443'
   ```

2. Either stop conflicting services or change port mappings in `docker-compose.yaml`

### Database Connection Issues

1. **Check database logs**:
   ```bash
   docker-compose logs db
   ```

2. **Verify database credentials** in both `db` and `app` services

## Customization

### Changing IPv6 Subnet

If you need to use a different IPv6 subnet:

1. Update `docker-compose.yaml`:
   ```yaml
   - subnet: YOUR_IPV6_SUBNET::/64
   ```

2. Update individual IPv6 addresses for each service

3. Update `/etc/docker/daemon.json` with the new subnet

4. Restart Docker daemon and recreate containers

### Adding SSL/TLS

1. Obtain SSL certificates (Let's Encrypt recommended)
2. Uncomment SSL configuration in `nginx.conf`
3. Mount certificate files in the `web` service
4. Update the configuration with your certificate paths

## File Structure

```
nextcloud/
├── docker-compose.yaml      # Main Docker Compose configuration
├── nginx.conf              # Nginx configuration for dual-stack
├── setup-docker-ipv6.sh    # Docker IPv6 setup script
└── README.md              # This file
```

## Environment Variables

You can customize the setup using environment variables:

```bash
# Database configuration
MYSQL_ROOT_PASSWORD=your_secure_root_password
MYSQL_PASSWORD=your_secure_password
MYSQL_DATABASE=nextcloud
MYSQL_USER=nextcloud

# Nextcloud configuration
NEXTCLOUD_ADMIN_USER=admin
NEXTCLOUD_ADMIN_PASSWORD=your_admin_password
```

Create a `.env` file in the same directory as `docker-compose.yaml` to use these variables.

## Monitoring

Monitor your services with:

```bash
# View all container status
docker-compose ps

# View logs
docker-compose logs -f

# View specific service logs
docker-compose logs -f web
docker-compose logs -f app
docker-compose logs -f db
```

## Backup

To backup your Nextcloud data:

```bash
# Backup volumes
docker run --rm -v nextcloud_nextcloud_data:/data -v $(pwd):/backup alpine tar czf /backup/nextcloud-data.tar.gz /data
docker run --rm -v nextcloud_db_data:/data -v $(pwd):/backup alpine tar czf /backup/nextcloud-db.tar.gz /data
```

## Support

For issues specific to this setup, check:
1. Docker logs: `docker-compose logs`
2. Network configuration: `docker network inspect nextcloud_nextcloud_network`
3. Service connectivity: `docker-compose exec web ping6 app`

For Nextcloud-specific issues, consult the [official Nextcloud documentation](https://docs.nextcloud.com/).
