FROM php:8.2-apache

# Install system dependencies
RUN apt-get update && apt-get install -y \
    git curl libpng-dev libonig-dev libxml2-dev zip unzip \
    sqlite3 libsqlite3-dev libzip-dev && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Install PHP extensions
RUN docker-php-ext-install pdo pdo_sqlite mbstring exif pcntl bcmath gd zip

# Get latest Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Set working directory
WORKDIR /var/www/html

# Copy application
COPY . .

# Create production .env
RUN printf '%s\n' \
    'APP_NAME="Brgy Sikatuna Village IMS"' \
    'APP_ENV=production' \
    'APP_KEY=base64:3gGQ4QLVbL3hl0JBcLZBUGWte2eOuKilirRHIPuOOFM=' \
    'APP_DEBUG=false' \
    'APP_URL=https://barangay-management-system-wc5e.onrender.com' \
    'DB_CONNECTION=sqlite' \
    'DB_DATABASE=database/database.sqlite' \
    'SESSION_DRIVER=file' \
    'CACHE_STORE=file' \
    'QUEUE_CONNECTION=sync' \
    'LOG_CHANNEL=stderr' \
    'LOG_LEVEL=error' > .env

# Setup database
RUN touch database/database.sqlite && chmod 777 database/database.sqlite

ENV COMPOSER_ALLOW_SUPERUSER=1

# Install dependencies
RUN composer install --no-dev --no-scripts --no-autoloader && \
    composer dump-autoload --optimize --no-dev

# Skip problematic migrations and run others
RUN mv database/migrations/*create_users_table.php database/migrations/create_users_table.php.skip 2>/dev/null || true && \
    rm -f database/migrations/2025_07_11_000000_remove_house_number_from_households_table.php && \
    php artisan migrate --force || echo "Some migrations failed"

# Execute SQL file to create users table and admin user
RUN sqlite3 database/database.sqlite < database/sql/users.sql

# Verify tables were created
RUN sqlite3 database/database.sqlite ".tables"

# Set permissions
RUN chown -R www-data:www-data /var/www/html && \
    chmod -R 755 /var/www/html/storage && \
    chmod 777 database/database.sqlite

# Configure Apache
RUN a2enmod rewrite && \
    printf '%s\n' \
    '<VirtualHost *:80>' \
    'DocumentRoot /var/www/html/public' \
    '<Directory /var/www/html/public>' \
    'AllowOverride All' \
    'Require all granted' \
    '</Directory>' \
    '</VirtualHost>' > /etc/apache2/sites-available/000-default.conf

EXPOSE 80
CMD ["apache2-foreground"]