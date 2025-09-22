# Complete Collaboration Stack Setup Guide

This Docker Compose setup provides a comprehensive collaboration and productivity platform with:

## Services Overview

### 🗂️ **Nextcloud** (Port 8080)
- **Purpose**: File storage, sharing, and collaboration platform
- **Features**: File sync, calendar, contacts, notes, and extensive app ecosystem
- **Access**: http://localhost:8080 or https://nextcloud.upturn.com.bd

### 📝 **OnlyOffice** (Port 8081)  
- **Purpose**: Document server for collaborative editing
- **Features**: Word, Excel, PowerPoint editing in browser with real-time collaboration
- **Integration**: Seamlessly integrated with Nextcloud for document editing

### 📊 **OpenProject** (Port 8082)
- **Purpose**: Project management and team collaboration
- **Features**: Gantt charts, agile boards, time tracking, wikis, forums
- **Access**: http://localhost:8082 or http://nextcloud.upturn.com.bd:8082

### 🗄️ **Supporting Services**
- **MariaDB**: Database for Nextcloud
- **PostgreSQL**: Database for OpenProject  
- **Redis**: Caching for Nextcloud
- **Memcached**: Caching for OpenProject

## Quick Start

### 1. Configure Environment Variables

Update the `.env` file with secure credentials:

```bash
# Generate secure values
MYSQL_PASSWORD=$(openssl rand -base64 32)
ONLYOFFICE_JWT_SECRET=$(openssl rand -hex 32)
OPENPROJECT_DB_PASSWORD=$(openssl rand -base64 32)
OPENPROJECT_SECRET_KEY_BASE=$(openssl rand -hex 64)
```

### 2. Start All Services

```bash
docker-compose up -d
```

### 3. Initial Setup Order

1. **Nextcloud** (5-10 minutes): Set up admin account and basic configuration
2. **OnlyOffice Integration**: Install OnlyOffice app in Nextcloud and configure connection
3. **OpenProject** (10-15 minutes first startup): Change default admin password

## Use Cases & Workflows

### 📋 Project Management Workflow
1. **Plan** projects in OpenProject (timelines, tasks, resources)
2. **Store** project files in Nextcloud (documents, assets, resources)  
3. **Edit** documents collaboratively using OnlyOffice
4. **Track** progress and time in OpenProject
5. **Collaborate** using OpenProject forums and Nextcloud sharing

### 👥 Team Collaboration
- **Document Management**: Nextcloud + OnlyOffice for real-time document collaboration
- **Project Planning**: OpenProject for task management and timeline planning
- **Knowledge Sharing**: OpenProject wikis + Nextcloud file organization
- **Communication**: OpenProject forums and news

### 🏢 Business Operations  
- **File Server**: Nextcloud as central file repository
- **Office Suite**: OnlyOffice for document creation/editing
- **Project Tracking**: OpenProject for deliverables and milestones
- **Client Collaboration**: Share specific folders/projects with external users

## Integration Opportunities

### Current Integrations
- ✅ **Nextcloud ↔ OnlyOffice**: Direct document editing integration
- ⚡ **Performance**: Redis caching for Nextcloud, Memcached for OpenProject

### Manual Workflow Integration  
- 📁 **File References**: Link OpenProject work packages to Nextcloud folders
- 📄 **Document Workflows**: Create documents in Nextcloud, track in OpenProject  
- 👥 **User Management**: Maintain consistent user accounts across platforms

### Future Enhancement Possibilities
- **SSO Integration**: Single sign-on across all platforms
- **API Integrations**: Custom workflows between systems
- **Backup Automation**: Coordinated backup of all services
- **Monitoring Stack**: Add monitoring for all services

## Resource Requirements

### Minimum System Requirements
- **RAM**: 4GB minimum, 8GB recommended
- **Storage**: 20GB+ for Docker images and initial data
- **CPU**: 2+ cores recommended

### Service Resource Usage
- **Nextcloud**: ~512MB RAM, moderate CPU
- **OnlyOffice**: ~1GB RAM, low CPU (document processing)
- **OpenProject**: ~2GB RAM, moderate CPU
- **Databases**: ~256MB each, low CPU

## Security Features

### Built-in Security
- 🔐 **JWT Authentication**: OnlyOffice ↔ Nextcloud communication
- 🗄️ **Database Isolation**: Separate containers for each database
- 🔒 **Environment Variables**: Secrets stored in `.env` file
- 🏥 **Health Checks**: Service monitoring and auto-restart

### Security Best Practices
1. **Strong Passwords**: Use generated passwords for all services
2. **Regular Updates**: Keep Docker images updated
3. **Reverse Proxy**: Use HTTPS in production (nginx/traefik)
4. **Backup Strategy**: Regular backups of all volumes
5. **Access Control**: Configure user permissions appropriately

## Backup Strategy

### Critical Volumes
```bash
# Nextcloud
nextcloud_data    # User files (CRITICAL)
nextcloud         # Application files  
db                # Nextcloud database (CRITICAL)

# OnlyOffice  
onlyoffice_data   # Document cache and temp files

# OpenProject
openproject_pgdata    # Project data (CRITICAL)
openproject_uploads   # User uploads (CRITICAL)
openproject_assets    # Can be regenerated
```

### Backup Commands
```bash
# Create backup directory
mkdir -p ./backups/$(date +%Y%m%d)

# Backup databases
docker-compose exec db mysqldump -u nextcloud -p nextcloud > backups/$(date +%Y%m%d)/nextcloud.sql
docker-compose exec openproject-db pg_dump -U openproject openproject > backups/$(date +%Y%m%d)/openproject.sql

# Backup volumes (requires downtime)
docker-compose down
tar -czf backups/$(date +%Y%m%d)/volumes.tar.gz /var/lib/docker/volumes/nextcloud_*
docker-compose up -d
```

## Maintenance

### Regular Tasks
- **Monthly**: Update Docker images
- **Weekly**: Check logs for errors
- **Daily**: Monitor disk space and performance

### Update Procedure
```bash
# Pull latest images
docker-compose pull

# Restart services with new images
docker-compose up -d

# Clean up old images
docker image prune
```

## Troubleshooting

### Common Issues
1. **Services won't start**: Check Docker logs and ensure ports are available
2. **OnlyOffice integration fails**: Verify JWT secret matches in both services
3. **Database connection errors**: Check database health and credentials
4. **Performance issues**: Monitor resource usage, consider scaling

### Useful Commands
```bash
# Check all service status
docker-compose ps

# View logs for specific service
docker-compose logs -f [service_name]

# Restart single service
docker-compose restart [service_name]

# Check resource usage
docker stats
```

## Getting Help

### Service-Specific Guides
- `ONLYOFFICE_SETUP.md` - Detailed OnlyOffice configuration
- `OPENPROJECT_SETUP.md` - Comprehensive OpenProject guide

### Official Documentation
- [Nextcloud Admin Manual](https://docs.nextcloud.com/server/latest/admin_manual/)
- [OnlyOffice Integration](https://api.onlyoffice.com/editors/nextcloud/)
- [OpenProject Documentation](https://www.openproject.org/docs/)

### Community Support
- Nextcloud Community Forums
- OpenProject Community Forum  
- OnlyOffice Developer Forums
