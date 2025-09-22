# OnlyOffice Integration with Nextcloud Setup Guide

## What's Been Added

1. **OnlyOffice Document Server**: Added as a new service in `compose.yaml`
   - Runs on port 8081 (accessible at http://localhost:8081)
   - JWT authentication enabled for security
   - Persistent volumes for data, logs, and cache

2. **Environment Variables**: Added `ONLYOFFICE_JWT_SECRET` to `.env` file

## Next Steps to Complete Setup

### 1. Update Environment Variables
Edit the `.env` file and replace the placeholder JWT secret:
```bash
# Generate a secure 32+ character random string
ONLYOFFICE_JWT_SECRET=your_actual_secure_random_secret_here
```

You can generate a secure JWT secret using:
```bash
openssl rand -hex 32
```

### 2. Start the Services
```bash
docker-compose up -d
```

### 3. Install OnlyOffice App in Nextcloud
1. Log into your Nextcloud admin panel
2. Go to Apps → Office & text
3. Install "OnlyOffice" app
4. Or use command line:
   ```bash
   docker-compose exec app php occ app:install onlyoffice
   ```

### 4. Configure OnlyOffice Integration
1. In Nextcloud, go to Settings → Administration → OnlyOffice
2. Set Document Editing Service address: `http://onlyoffice/`
3. Set Secret key: Use the same value as `ONLYOFFICE_JWT_SECRET`
4. Test the connection

### 5. Optional: Configure for External Access
If you want OnlyOffice accessible externally (like your Nextcloud), you'll need to:

1. Add OnlyOffice to your reverse proxy configuration
2. Update the Document Editing Service address to your external OnlyOffice URL
3. Ensure JWT secret matches between services

## Features You'll Get

- **Document Editing**: Edit Word, Excel, PowerPoint files directly in browser
- **Collaborative Editing**: Multiple users can edit simultaneously
- **Version History**: Track document changes
- **Comments and Review**: Add comments and suggestions
- **Integration**: Seamless integration with Nextcloud Files

## Troubleshooting

- Check logs: `docker-compose logs onlyoffice`
- Verify OnlyOffice health: `curl http://localhost:8081/healthcheck`
- Ensure JWT secrets match between Nextcloud and OnlyOffice configurations
- Check network connectivity between containers

## Security Notes

- JWT authentication is enabled by default for security
- OnlyOffice runs in its own container with limited access
- Data is persisted in Docker volumes
- Consider running behind HTTPS in production
