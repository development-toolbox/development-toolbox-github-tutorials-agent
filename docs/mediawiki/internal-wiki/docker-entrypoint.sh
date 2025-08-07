#!/bin/bash
set -e

# Wait for database to be ready
echo "Waiting for database..."
until mysql -h"$MEDIAWIKI_DB_HOST" -u"$MEDIAWIKI_DB_USER" -p"$MEDIAWIKI_DB_PASSWORD" -e "SELECT 1" &> /dev/null
do
    echo "Database is unavailable - sleeping"
    sleep 2
done

echo "Database is ready!"

# Run MediaWiki update script if LocalSettings.php exists
if [ -f /var/www/html/LocalSettings.php ]; then
    echo "Running MediaWiki database updates..."
    php /var/www/html/maintenance/update.php --quick
fi

# Import initial content if it exists and database is empty
if [ -d /var/www/html/content ] && [ -z "$(mysql -h"$MEDIAWIKI_DB_HOST" -u"$MEDIAWIKI_DB_USER" -p"$MEDIAWIKI_DB_PASSWORD" "$MEDIAWIKI_DB_NAME" -e "SELECT 1 FROM page LIMIT 1" 2>/dev/null)" ]; then
    echo "Importing initial wiki content..."
    for file in /var/www/html/content/*.xml; do
        if [ -f "$file" ]; then
            echo "Importing $file..."
            php /var/www/html/maintenance/importDump.php < "$file"
        fi
    done
    
    # Rebuild search index after import
    php /var/www/html/maintenance/rebuildtextindex.php
fi

# Create admin user if it doesn't exist
php /var/www/html/maintenance/createAndPromote.php --force --sysop "WikiAdmin" "AdminPassword123!"

# Execute the original MediaWiki entrypoint
exec "$@"