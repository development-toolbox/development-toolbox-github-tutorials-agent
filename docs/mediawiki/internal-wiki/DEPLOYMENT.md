# GitHub Enterprise Wiki Deployment Guide

This guide provides comprehensive instructions for deploying the GitHub Enterprise Internal Wiki using Docker Compose.

## 📋 Prerequisites

### System Requirements

- **Operating System**: Linux (Ubuntu 20.04+ recommended), macOS, or Windows with WSL2
- **RAM**: Minimum 4GB, recommended 8GB
- **Storage**: Minimum 10GB free space
- **Network**: Internet access for downloading Docker images

### Required Software

```bash
# Ubuntu/Debian
sudo apt update
sudo apt install -y docker.io docker-compose git curl

# Enable Docker service
sudo systemctl enable docker
sudo systemctl start docker

# Add user to docker group (logout/login required)
sudo usermod -aG docker $USER

# CentOS/RHEL/Fedora
sudo dnf install -y docker docker-compose git curl
sudo systemctl enable --now docker
sudo usermod -aG docker $USER

# macOS (using Homebrew)
brew install docker docker-compose git

# Windows (WSL2)
# Install Docker Desktop for Windows with WSL2 backend
```

### Verify Installation

```bash
docker --version
docker-compose --version
git --version
```

## 🚀 Quick Deployment

### 1. Download and Setup

```bash
# Create deployment directory
mkdir -p /opt/github-wiki
cd /opt/github-wiki

# Download the configuration files
# (Replace with your actual repository or copy files manually)
git clone https://github.com/your-org/github-wiki-config.git .

# Or manually create the directory structure:
mkdir -p content templates
```

### 2. Configuration

```bash
# Copy the example configuration
cp LocalSettings.php.example LocalSettings.php

# Edit configuration with your settings
nano LocalSettings.php
```

**Critical settings to change:**

```php
# Change these in LocalSettings.php
$wgDBpassword = "your_secure_database_password";
$wgSecretKey = "your_64_character_secret_key";
$wgUpgradeKey = "your_upgrade_key";

# For production, set your domain
$wgServer = "https://wiki.yourcompany.com";
```

### 3. Generate Secure Keys

```bash
# Generate secret key (64 characters)
openssl rand -hex 32

# Generate upgrade key
openssl rand -hex 16
```

### 4. Start Services

```bash
# Start all services
docker-compose up -d

# Monitor startup logs
docker-compose logs -f mediawiki
```

### 5. Initial Setup

```bash
# Wait for services to be ready (2-3 minutes)
curl -I http://localhost:8080

# Create admin user (change credentials!)
docker exec -it github-wiki php /var/www/html/maintenance/createAndPromote.php \
  --force --sysop --custom-groups=admin "WikiAdmin" "YourSecurePassword123!"

# Import initial content
./maintenance.sh import-content

# Rebuild search index
./maintenance.sh rebuild-search
```

## 🏗️ Detailed Deployment

### Step 1: Environment Preparation

Create the deployment structure:

```bash
# Create directory structure
mkdir -p /opt/github-wiki/{content,templates,extensions,ssl,backups}
cd /opt/github-wiki

# Set proper permissions
chmod 755 /opt/github-wiki
```

### Step 2: Docker Compose Configuration

Create or verify `docker-compose.yml`:

```yaml
version: '3.8'

services:
  database:
    image: mariadb:10.11
    container_name: wiki-mariadb
    restart: unless-stopped
    environment:
      MYSQL_DATABASE: github_wiki
      MYSQL_USER: wikiuser
      MYSQL_PASSWORD: ${DB_PASSWORD:-change_this_password}
      MYSQL_RANDOM_ROOT_PASSWORD: 'yes'
    volumes:
      - db_data:/var/lib/mysql
      - ./backups:/backups
    networks:
      - wiki-network
    healthcheck:
      test: ["CMD", "mysqladmin", "ping", "-h", "localhost"]
      timeout: 20s
      retries: 10

  memcached:
    image: memcached:alpine
    container_name: wiki-memcached
    restart: unless-stopped
    command: memcached -m 256
    networks:
      - wiki-network

  elasticsearch:
    image: docker.elastic.co/elasticsearch/elasticsearch:7.17.9
    container_name: wiki-elasticsearch
    restart: unless-stopped
    environment:
      - discovery.type=single-node
      - "ES_JAVA_OPTS=-Xms512m -Xmx512m"
      - xpack.security.enabled=false
    volumes:
      - es_data:/usr/share/elasticsearch/data
    networks:
      - wiki-network

  mediawiki:
    build:
      context: .
      dockerfile: Dockerfile
    container_name: github-wiki
    restart: unless-stopped
    ports:
      - "${WIKI_PORT:-8080}:80"
    environment:
      MEDIAWIKI_DB_HOST: database
      MEDIAWIKI_DB_USER: wikiuser
      MEDIAWIKI_DB_PASSWORD: ${DB_PASSWORD:-change_this_password}
      MEDIAWIKI_DB_NAME: github_wiki
    volumes:
      - ./LocalSettings.php:/var/www/html/LocalSettings.php
      - ./content:/var/www/html/content
      - images:/var/www/html/images
      - ./extensions:/var/www/html/extensions-custom
    depends_on:
      database:
        condition: service_healthy
    networks:
      - wiki-network

  parsoid:
    image: thenets/parsoid:0.11
    container_name: wiki-parsoid
    restart: unless-stopped
    environment:
      PARSOID_DOMAIN_localhost: http://mediawiki/api.php
    networks:
      - wiki-network

volumes:
  db_data:
  es_data:
  images:

networks:
  wiki-network:
    driver: bridge
```

### Step 3: Environment Variables

Create `.env` file:

```bash
# Database
DB_PASSWORD=your_secure_database_password_here

# Wiki
WIKI_PORT=8080
WIKI_NAME="GitHub Enterprise Wiki"
WIKI_ADMIN_EMAIL=admin@yourcompany.com

# Security (generate these!)
SECRET_KEY=your_64_character_secret_key_here
UPGRADE_KEY=your_upgrade_key_here
```

### Step 4: SSL/HTTPS Setup (Production)

For production deployment with HTTPS:

```bash
# Create SSL directory
mkdir -p ssl

# Option 1: Use Let's Encrypt (recommended)
docker run --rm -v $(pwd)/ssl:/etc/letsencrypt certbot/certbot certonly \
  --standalone -d wiki.yourcompany.com \
  --email admin@yourcompany.com --agree-tos

# Option 2: Use existing certificates
cp your-certificate.crt ssl/
cp your-private-key.key ssl/
```

Create `docker-compose.override.yml` for HTTPS:

```yaml
version: '3.8'

services:
  nginx:
    image: nginx:alpine
    container_name: wiki-nginx
    restart: unless-stopped
    ports:
      - "80:80"
      - "443:443"
    volumes:
      - ./nginx.conf:/etc/nginx/nginx.conf
      - ./ssl:/etc/nginx/ssl
    depends_on:
      - mediawiki
    networks:
      - wiki-network
```

Create `nginx.conf`:

```nginx
events {
    worker_connections 1024;
}

http {
    upstream mediawiki {
        server mediawiki:80;
    }

    server {
        listen 80;
        server_name wiki.yourcompany.com;
        return 301 https://$server_name$request_uri;
    }

    server {
        listen 443 ssl http2;
        server_name wiki.yourcompany.com;

        ssl_certificate /etc/nginx/ssl/fullchain.pem;
        ssl_certificate_key /etc/nginx/ssl/privkey.pem;

        client_max_body_size 100M;

        location / {
            proxy_pass http://mediawiki;
            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_set_header X-Forwarded-Proto https;
        }
    }
}
```

### Step 5: Start and Verify Deployment

```bash
# Start services
docker-compose up -d

# Check service status
docker-compose ps

# Follow startup logs
docker-compose logs -f

# Test connectivity
curl -I http://localhost:8080
```

## 🔧 Post-Deployment Configuration

### 1. Create Administrator Accounts

```bash
# Create first admin user
docker exec -it github-wiki php /var/www/html/maintenance/createAndPromote.php \
  --force --sysop --custom-groups=admin "WikiAdmin" "SecurePassword123!"

# Create additional admin users
docker exec -it github-wiki php /var/www/html/maintenance/createAndPromote.php \
  --force --sysop --custom-groups=admin "jane.doe" "AnotherSecurePassword456!"
```

### 2. Import Initial Content

```bash
# Import wiki pages
./maintenance.sh import-content

# Update search index
./maintenance.sh rebuild-search

# Update localisation cache
docker exec -it github-wiki php /var/www/html/maintenance/rebuildLocalisationCache.php
```

### 3. Configure Extensions

```bash
# Update database for extensions
docker exec -it github-wiki php /var/www/html/maintenance/update.php --quick

# Enable Visual Editor
# (Already configured in LocalSettings.php, but verify it works)
curl -X POST "http://localhost:8080/api.php" \
  -d "action=query&format=json&meta=siteinfo&siprop=extensions"
```

### 4. Set Up Backups

Create backup script `/opt/github-wiki/backup.sh`:

```bash
#!/bin/bash
BACKUP_DIR="/opt/github-wiki/backups"
DATE=$(date +%Y%m%d_%H%M%S)

# Create backup directory
mkdir -p "$BACKUP_DIR"

# Database backup
docker exec wiki-mariadb mysqldump -u wikiuser -p$DB_PASSWORD github_wiki > "$BACKUP_DIR/database_$DATE.sql"

# Files backup
docker exec github-wiki tar -czf "/backups/images_$DATE.tar.gz" -C /var/www/html images

# Wiki content export
docker exec github-wiki php /var/www/html/maintenance/dumpBackup.php --full > "$BACKUP_DIR/content_$DATE.xml"

# Cleanup old backups (keep last 7 days)
find "$BACKUP_DIR" -name "*.sql" -mtime +7 -delete
find "$BACKUP_DIR" -name "*.tar.gz" -mtime +7 -delete
find "$BACKUP_DIR" -name "*.xml" -mtime +7 -delete

echo "Backup completed: $DATE"
```

```bash
# Make executable
chmod +x backup.sh

# Add to cron (daily at 2 AM)
echo "0 2 * * * /opt/github-wiki/backup.sh" | crontab -
```

## 🔍 Health Checks and Monitoring

### Service Health Verification

```bash
# Check all services
./health-check.sh
```

Create `health-check.sh`:

```bash
#!/bin/bash
echo "=== GitHub Wiki Health Check ==="

# Service status
echo "Docker services:"
docker-compose ps

# Database connectivity
echo -n "Database: "
if docker exec wiki-mariadb mysql -u wikiuser -p$DB_PASSWORD -e "SELECT 1;" &>/dev/null; then
    echo "✅ Connected"
else
    echo "❌ Failed"
fi

# MediaWiki API
echo -n "MediaWiki API: "
if curl -s -f http://localhost:8080/api.php?action=query\&meta=siteinfo >/dev/null; then
    echo "✅ Responding"
else
    echo "❌ Not responding"
fi

# Elasticsearch
echo -n "Elasticsearch: "
if curl -s -f http://localhost:9200/_cluster/health >/dev/null; then
    echo "✅ Healthy"
else
    echo "❌ Unhealthy"
fi

# Disk usage
echo "Disk usage:"
df -h /opt/github-wiki
```

### Log Monitoring

```bash
# View logs
docker-compose logs -f mediawiki
docker-compose logs -f database
docker-compose logs -f elasticsearch

# Log rotation setup
cat > /etc/logrotate.d/docker-compose << EOF
/opt/github-wiki/logs/*.log {
    daily
    missingok
    rotate 7
    compress
    notifempty
    create 644 root root
    postrotate
        docker-compose -f /opt/github-wiki/docker-compose.yml restart
    endscript
}
EOF
```

## 🔒 Security Configuration

### 1. Firewall Setup

```bash
# Ubuntu/Debian (UFW)
sudo ufw allow ssh
sudo ufw allow 80/tcp
sudo ufw allow 443/tcp
sudo ufw enable

# CentOS/RHEL (firewalld)
sudo firewall-cmd --permanent --add-service=ssh
sudo firewall-cmd --permanent --add-service=http
sudo firewall-cmd --permanent --add-service=https
sudo firewall-cmd --reload
```

### 2. Docker Security

```bash
# Enable Docker content trust
echo 'export DOCKER_CONTENT_TRUST=1' >> ~/.bashrc

# Scan images for vulnerabilities
docker run --rm -v /var/run/docker.sock:/var/run/docker.sock \
  aquasec/trivy image mediawiki:1.39
```

### 3. MediaWiki Security

Update `LocalSettings.php` for production:

```php
# Disable debug information
$wgShowExceptionDetails = false;
$wgDebugToolbar = false;
$wgShowDBErrorBacktrace = false;

# Enable additional security features
$wgDisableOutputCompression = false;
$wgSecureLogin = true;
$wgSecureCookies = true;
$wgCookieSecure = true;
$wgCookieHttpOnly = true;

# Rate limiting
$wgRateLimits['edit']['user'] = [ 8, 60 ];
$wgRateLimits['move']['user'] = [ 2, 60 ];
$wgRateLimits['upload']['user'] = [ 10, 300 ];
```

## 🔧 Troubleshooting

### Common Issues

**Services won't start:**
```bash
# Check logs
docker-compose logs

# Restart services
docker-compose down
docker-compose up -d

# Clean Docker system
docker system prune -f
```

**Database connection errors:**
```bash
# Check database status
docker-compose logs database

# Verify credentials
docker exec -it wiki-mariadb mysql -u wikiuser -p

# Reset database
docker-compose down -v
docker-compose up -d
```

**Permission errors:**
```bash
# Fix file permissions
docker exec github-wiki chown -R www-data:www-data /var/www/html/images
docker exec github-wiki chmod -R 755 /var/www/html/images
```

**Memory issues:**
```bash
# Check memory usage
docker stats

# Adjust memory limits in docker-compose.yml
services:
  mediawiki:
    deploy:
      resources:
        limits:
          memory: 2G
```

## 📈 Performance Optimization

### 1. Caching Configuration

```php
# In LocalSettings.php
$wgMainCacheType = CACHE_MEMCACHED;
$wgMemCachedServers = array( "memcached:11211" );
$wgParserCacheType = CACHE_MEMCACHED;
$wgMessageCacheType = CACHE_MEMCACHED;
$wgObjectCacheSessionExpiry = 3600;
```

### 2. Database Optimization

```bash
# Optimize database tables
docker exec github-wiki php /var/www/html/maintenance/sql.php -e "OPTIMIZE TABLE page, revision, text;"

# Update database statistics  
docker exec wiki-mariadb mysql -u wikiuser -p$DB_PASSWORD github_wiki -e "ANALYZE TABLE page, revision, text;"
```

### 3. Elasticsearch Tuning

```yaml
# In docker-compose.yml
elasticsearch:
  environment:
    - "ES_JAVA_OPTS=-Xms1g -Xmx1g"  # Increase memory
    - thread_pool.write.queue_size=1000
```

## 🆙 Updates and Maintenance

### MediaWiki Updates

```bash
# Update to new MediaWiki version
# 1. Backup first
./backup.sh

# 2. Update docker-compose.yml with new version
# 3. Pull new image
docker-compose pull mediawiki

# 4. Update database
docker-compose up -d
./maintenance.sh update-db

# 5. Clear cache
./maintenance.sh clear-cache
```

### Extension Updates

```bash
# Update extensions
docker exec github-wiki bash -c "
  cd /var/www/html/extensions
  for dir in */; do
    if [ -d \"\$dir/.git\" ]; then
      echo \"Updating \$dir\"
      cd \"\$dir\"
      git pull
      cd ..
    fi
  done
"

# Update database after extension updates
./maintenance.sh update-db
```

## 📞 Support and Documentation

### Getting Help

- **MediaWiki Documentation**: https://www.mediawiki.org/wiki/Manual:Contents
- **Docker Documentation**: https://docs.docker.com/
- **GitHub Issues**: Create issues in your repository

### Log Locations

```bash
# Application logs
docker-compose logs mediawiki

# Database logs  
docker-compose logs database

# System logs
journalctl -u docker
```

This completes the comprehensive deployment guide for the GitHub Enterprise Internal Wiki. Follow these instructions carefully and adapt the configuration to your specific requirements.