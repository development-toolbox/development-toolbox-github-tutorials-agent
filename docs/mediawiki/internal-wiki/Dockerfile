FROM mediawiki:1.39

# Install required system packages
RUN apt-get update && apt-get install -y \
    git \
    zip \
    unzip \
    libzip-dev \
    && docker-php-ext-install zip \
    && rm -rf /var/lib/apt/lists/*

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Install required MediaWiki extensions
RUN cd /var/www/html/extensions \
    && git clone --depth 1 -b REL1_39 https://gerrit.wikimedia.org/r/mediawiki/extensions/Lockdown.git \
    && git clone --depth 1 -b REL1_39 https://gerrit.wikimedia.org/r/mediawiki/extensions/CirrusSearch.git \
    && git clone --depth 1 -b REL1_39 https://gerrit.wikimedia.org/r/mediawiki/extensions/Elastica.git \
    && git clone --depth 1 -b REL1_39 https://gerrit.wikimedia.org/r/mediawiki/extensions/TemplateStyles.git \
    && git clone --depth 1 -b REL1_39 https://gerrit.wikimedia.org/r/mediawiki/extensions/TimedMediaHandler.git

# Install Elastica dependencies via Composer
RUN cd /var/www/html/extensions/Elastica \
    && composer install --no-dev

# Set proper permissions
RUN chown -R www-data:www-data /var/www/html/extensions \
    && chmod -R 755 /var/www/html/extensions

# Create custom directories
RUN mkdir -p /var/www/html/content \
    && chown www-data:www-data /var/www/html/content

# Copy maintenance script
COPY maintenance.sh /maintenance.sh
RUN chmod +x /maintenance.sh

# Expose port
EXPOSE 80

# Set up entrypoint
COPY docker-entrypoint.sh /docker-entrypoint.sh
RUN chmod +x /docker-entrypoint.sh

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["apache2-foreground"]