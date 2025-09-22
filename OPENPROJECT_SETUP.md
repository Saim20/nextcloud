# OpenProject Integration Setup Guide

## What's Been Added

OpenProject is a comprehensive project management and collaboration platform that includes:

### Services Added:
1. **openproject**: Main application server (port 8082)
2. **openproject-db**: PostgreSQL database for OpenProject
3. **openproject-cache**: Memcached for improved performance

### Volumes Added:
- `openproject_pgdata`: PostgreSQL database storage
- `openproject_assets`: Static assets and compiled files
- `openproject_uploads`: User uploaded files and attachments

## Environment Variables Added

- `OPENPROJECT_DB_PASSWORD`: Database password for PostgreSQL
- `OPENPROJECT_SECRET_KEY_BASE`: Secret key for OpenProject security

## Setup Steps

### 1. Update Environment Variables

Edit the `.env` file and set secure values:

```bash
# Generate secure passwords/keys:
OPENPROJECT_DB_PASSWORD=$(openssl rand -base64 32)
OPENPROJECT_SECRET_KEY_BASE=$(openssl rand -hex 64)
```

Or manually set them:
```bash
OPENPROJECT_DB_PASSWORD=your_very_secure_db_password_here
OPENPROJECT_SECRET_KEY_BASE=your_very_long_secret_key_base_at_least_64_characters_long
```

### 2. Start the Services

```bash
# Start all services
docker-compose up -d

# Check OpenProject logs during first startup (it takes a few minutes)
docker-compose logs -f openproject
```

**Note**: First startup takes 5-10 minutes as OpenProject initializes the database and compiles assets.

### 3. Access OpenProject

- URL: http://localhost:8082 or http://nextcloud.upturn.com.bd:8082
- Default admin credentials:
  - Username: `admin`
  - Password: `admin`

**Important**: Change the admin password immediately after first login!

### 4. Initial Configuration

1. **Change admin password**: Go to Administration → Users → admin → Change password
2. **Configure system settings**: Administration → System settings
3. **Set up email**: Administration → Email notifications
4. **Create projects**: Click "+ Project" to start creating your first project

## OpenProject Features

### Project Management
- **Work packages**: Tasks, bugs, features with custom fields
- **Gantt charts**: Timeline and dependency visualization  
- **Agile boards**: Kanban and Scrum boards
- **Time tracking**: Log time spent on tasks
- **Cost tracking**: Budget management and cost reporting

### Collaboration
- **Team planner**: Resource allocation and capacity planning
- **Wiki**: Project documentation and knowledge base
- **Forums**: Discussion boards per project
- **News**: Project announcements
- **Document management**: File sharing and version control

### Integration Capabilities
- **Git integration**: Connect with GitLab, GitHub, etc.
- **API access**: REST API for integrations
- **LDAP/SSO**: Enterprise authentication
- **Custom fields**: Extend work packages and projects

## Integration with Nextcloud

While there's no direct integration, you can:

1. **File Management**: Store project files in Nextcloud, reference in OpenProject
2. **Document Collaboration**: Use OnlyOffice for document editing, OpenProject for project planning
3. **Workflow**: 
   - Plan projects in OpenProject
   - Store/edit documents in Nextcloud + OnlyOffice
   - Track progress in OpenProject

## Port Configuration

- **Nextcloud**: 8080
- **OnlyOffice**: 8081  
- **OpenProject**: 8082

## Backup Considerations

Important volumes to backup:
- `openproject_pgdata`: Database (critical)
- `openproject_uploads`: User files
- `openproject_assets`: Can be regenerated but saves time

## Performance Tuning

For production use, consider:

1. **Resource allocation**:
   ```yaml
   deploy:
     resources:
       limits:
         memory: 2G
         cpus: '1.0'
   ```

2. **Database optimization**: Tune PostgreSQL settings
3. **Caching**: Memcached is already configured
4. **Worker processes**: Adjust `OPENPROJECT_WEB__WORKERS` based on load

## Troubleshooting

### Common Issues:
1. **Slow startup**: Normal for first time, check logs
2. **Database connection**: Ensure PostgreSQL is healthy
3. **Memory issues**: OpenProject needs at least 2GB RAM
4. **Assets not loading**: Check volume mounts and permissions

### Useful Commands:
```bash
# Check service health
docker-compose ps

# View logs
docker-compose logs openproject
docker-compose logs openproject-db

# Restart OpenProject only
docker-compose restart openproject

# Access OpenProject console (for advanced troubleshooting)
docker-compose exec openproject bash
```

### Health Checks:
- OpenProject: http://localhost:8082/health_checks/default
- Database status via logs

## Security Notes

- Change default admin credentials immediately
- Use strong passwords in environment variables
- Consider running behind reverse proxy with HTTPS
- Regular security updates via image updates
- Database is isolated in its own container

## Next Steps

1. Set up your first project
2. Invite team members
3. Configure project templates
4. Set up integrations (Git, email, etc.)
5. Customize work package types and workflows
