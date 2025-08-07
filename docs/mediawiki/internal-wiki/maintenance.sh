#!/bin/bash
# MediaWiki maintenance script for Docker container

echo "MediaWiki Maintenance Script"
echo "============================"

case "$1" in
    "rebuild-search")
        echo "Rebuilding search index..."
        docker exec -it github-wiki php /var/www/html/maintenance/rebuildtextindex.php
        docker exec -it github-wiki php /var/www/html/extensions/CirrusSearch/maintenance/UpdateSearchIndexConfig.php
        docker exec -it github-wiki php /var/www/html/extensions/CirrusSearch/maintenance/ForceSearchIndex.php --skipLinks --indexOnSkip
        ;;
    
    "update-db")
        echo "Updating database schema..."
        docker exec -it github-wiki php /var/www/html/maintenance/update.php
        ;;
    
    "create-admin")
        echo "Creating admin user..."
        read -p "Username: " username
        read -s -p "Password: " password
        echo
        docker exec -it github-wiki php /var/www/html/maintenance/createAndPromote.php --force --sysop --custom-groups=admin "$username" "$password"
        ;;
    
    "import-content")
        echo "Importing wiki content..."
        docker exec -it github-wiki bash -c 'for file in /var/www/html/content/*.xml; do php /var/www/html/maintenance/importDump.php < "$file"; done'
        ;;
    
    "export-content")
        echo "Exporting wiki content..."
        docker exec -it github-wiki php /var/www/html/maintenance/dumpBackup.php --full > backup-$(date +%Y%m%d-%H%M%S).xml
        ;;
    
    "clear-cache")
        echo "Clearing MediaWiki cache..."
        docker exec -it github-wiki php /var/www/html/maintenance/rebuildLocalisationCache.php
        docker exec -it github-wiki php /var/www/html/maintenance/purgeList.php --all
        ;;
    
    *)
        echo "Usage: $0 {rebuild-search|update-db|create-admin|import-content|export-content|clear-cache}"
        exit 1
        ;;
esac

echo "Done!"