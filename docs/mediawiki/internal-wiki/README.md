# GitHub Enterprise Internal Wiki

A comprehensive MediaWiki-based internal documentation system for GitHub best practices, tutorials, and enterprise administration.

## 🚀 Quick Start

### Prerequisites

- Docker and Docker Compose
- At least 4GB of available RAM
- 10GB of available disk space

### 1. Initial Setup

```bash
# Clone or copy the wiki files to your server
git clone <your-repo> github-wiki
cd github-wiki

# Make scripts executable
chmod +x maintenance.sh docker-entrypoint.sh

# Start the services
docker-compose up -d
```

### 2. First-Time Configuration

```bash
# Wait for services to start (2-3 minutes)
docker-compose logs -f mediawiki

# Access the wiki at http://localhost:8080
# Default admin credentials:
# Username: WikiAdmin
# Password: AdminPassword123!
```

### 3. Initial Content Import

```bash
# Import wiki content (if you have XML dumps)
./maintenance.sh import-content

# Rebuild search index
./maintenance.sh rebuild-search
```

## 🏗️ Architecture

### Services

- **mediawiki**: Main MediaWiki application (port 8080)
- **database**: MariaDB database
- **memcached**: Caching layer
- **elasticsearch**: Search engine
- **parsoid**: Visual Editor support
- **restbase**: API gateway for Visual Editor

### Volumes

- `images`: User-uploaded files
- `db_data`: Database storage
- `es_data`: Elasticsearch indexes

## 👥 User Access Control

### Permission Groups

- **Anonymous users**: No access (login required)
- **Regular users**: Read/write access to main content
- **Admin group**: Full access including Admin: namespace

### Admin Namespace

The `Admin:` namespace is restricted to administrators only and contains:
- User management guides
- Security configuration
- Enterprise settings
- System administration procedures

## 📚 Content Structure

### User Tutorials

Organised by difficulty level:

- **Beginner**: Getting started, basic Git, GitHub fundamentals
- **Intermediate**: Actions, collaboration, project management
- **Advanced**: Enterprise features, security, API integration

### Categories

- `Category:Beginner Tutorials`
- `Category:Intermediate Tutorials` 
- `Category:Advanced Tutorials`
- `Category:GitHub Actions`
- `Category:Security`
- `Category:Enterprise`
- `Category:API`

### Templates

- `{{TutorialInfo}}`: Tutorial metadata (level, duration, prerequisites)
- `{{Note}}`: Information boxes
- `{{Warning}}`: Warning boxes
- `{{Critical}}`: Critical alerts
- `{{Good}}`: Best practice boxes
- `{{Exercise}}`: Hands-on exercises
- `{{Navigation}}`: Tutorial navigation
- `{{AdminOnly}}`: Admin restriction notice

## 🔧 Administration

### Creating Admin Users

```bash
./maintenance.sh create-admin
# Or via Docker:
docker exec -it github-wiki php /var/www/html/maintenance/createAndPromote.php --force --sysop --custom-groups=admin "username" "password"
```

### Adding Users to Admin Group

1. Log in as an admin
2. Go to Special:UserRights
3. Enter username and add to "admin" group

### Managing Content

```bash
# Update database schema
./maintenance.sh update-db

# Clear cache
./maintenance.sh clear-cache

# Export content
./maintenance.sh export-content

# Rebuild search index
./maintenance.sh rebuild-search
```

### Backup and Recovery

```bash
# Create full backup
docker exec github-wiki php /var/www/html/maintenance/dumpBackup.php --full > backup.xml

# Backup database
docker exec wiki-mariadb mysqldump -u wikiuser -pexample my_wiki > database-backup.sql

# Backup uploaded files
docker cp github-wiki:/var/www/html/images ./images-backup
```

## 🛠️ Customisation

### Adding Extensions

1. Add extension to `Dockerfile`:
```dockerfile
RUN cd /var/www/html/extensions \
    && git clone --depth 1 -b REL1_39 https://gerrit.wikimedia.org/r/mediawiki/extensions/ExtensionName.git
```

2. Enable in `LocalSettings.php`:
```php
wfLoadExtension( 'ExtensionName' );
```

3. Rebuild container:
```bash
docker-compose build mediawiki
docker-compose up -d
```

### Custom Styling

Edit `MediaWiki:Common.css` after login to customise appearance.

### Logo and Branding

Replace the logo in `LocalSettings.php`:
```php
$wgLogos = [ '1x' => "$wgResourceBasePath/resources/assets/company-logo.png" ];
```

## 🔒 Security Configuration

### SSL/TLS Setup

For production, configure HTTPS:

```yaml
# docker-compose.override.yml
services:
  nginx:
    image: nginx:alpine
    ports:
      - "443:443"
    volumes:
      - ./nginx.conf:/etc/nginx/nginx.conf
      - ./ssl:/etc/nginx/ssl
    depends_on:
      - mediawiki
```

### SAML/SSO Integration

Configure in `LocalSettings.php`:

```php
wfLoadExtension( 'SimpleSAMLphp' );
$wgSimpleSAMLphp_InstallDir = '/var/www/simplesamlphp';
$wgSimpleSAMLphp_AuthSourceId = 'default-sp';
$wgSimpleSAMLphp_RealNameAttribute = 'cn';
$wgSimpleSAMLphp_EmailAttribute = 'mail';
$wgSimpleSAMLphp_UsernameAttribute = 'uid';
```

### API Security

```php
# Restrict API access
$wgGroupPermissions['*']['writeapi'] = false;
$wgGroupPermissions['user']['writeapi'] = true;

# Rate limiting
$wgRateLimits['edit']['user'] = [ 8, 60 ];
$wgRateLimits['move']['user'] = [ 2, 60 ];
```

## 🔍 Monitoring

### Health Checks

```bash
# Check service status
docker-compose ps

# View logs
docker-compose logs mediawiki
docker-compose logs database

# Performance monitoring
docker stats
```

### Database Maintenance

```bash
# Optimise database
docker exec github-wiki php /var/www/html/maintenance/sql.php -e "OPTIMIZE TABLE page, revision, text;"

# Check database integrity
docker exec github-wiki php /var/www/html/maintenance/checkBadRedirects.php
```

## 🔄 Updates

### MediaWiki Updates

1. Update Docker image version in `docker-compose.yml`
2. Run database update: `./maintenance.sh update-db`
3. Clear cache: `./maintenance.sh clear-cache`

### Extension Updates

```bash
# Update extensions
docker exec github-wiki bash -c "cd /var/www/html/extensions && find . -name .git -type d | while read d; do cd \$d/..; git pull; cd -; done"

# Update database
./maintenance.sh update-db
```

## 🐛 Troubleshooting

### Common Issues

**Services won't start:**
```bash
docker-compose down
docker system prune -f
docker-compose up -d
```

**Database connection errors:**
- Check database credentials in `LocalSettings.php`
- Ensure database service is running: `docker-compose ps database`

**Search not working:**
```bash
./maintenance.sh rebuild-search
```

**Permission errors:**
```bash
docker exec github-wiki chown -R www-data:www-data /var/www/html/images
```

### Log Locations

- MediaWiki logs: `docker-compose logs mediawiki`
- Database logs: `docker-compose logs database`
- Web server logs: Inside container at `/var/log/apache2/`

## 📞 Support

For technical support:
- Check the [MediaWiki documentation](https://www.mediawiki.org/wiki/Manual:Contents)
- Review Docker logs for error messages
- Check the GitHub repository issues

## 📋 Production Checklist

Before deploying to production:

- [ ] Change default passwords in `LocalSettings.php`
- [ ] Configure SSL/TLS certificates
- [ ] Set up automated backups
- [ ] Configure monitoring and alerting
- [ ] Review security settings
- [ ] Test user authentication (SAML/SSO)
- [ ] Verify admin namespace restrictions
- [ ] Set up log rotation
- [ ] Configure firewall rules
- [ ] Document admin procedures

## 📄 License

This wiki structure and content is provided under the MIT License. MediaWiki itself is licensed under the GPL.