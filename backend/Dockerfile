FROM php:8.2-apache

# Install system dependencies
RUN apt-get update && apt-get install -y \
    git \
    curl \
    libpng-dev \
    libonig-dev \
    libxml2-dev \
    zip \
    unzip \
    sqlite3 \
    libsqlite3-dev \
    libzip-dev

# Clear cache
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# Install PHP extensions
RUN docker-php-ext-install pdo pdo_sqlite mbstring exif pcntl bcmath gd zip

# Get latest Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Set working directory
WORKDIR /var/www/html

# Copy application
COPY . .

# Setup database and dependencies
RUN touch database/database.sqlite && chmod 777 database/database.sqlite

ENV COMPOSER_ALLOW_SUPERUSER=1

RUN composer install --no-dev --optimize-autoloader

RUN php artisan key:generate --force || true

# Debug: Check if database file exists
RUN ls -la database/

# Debug: Check migration files
RUN ls -la database/migrations/

# Run migrations with verbose output
RUN php artisan migrate --force --verbose || echo "Migration failed"

# Debug: Check if users table exists
RUN sqlite3 database/database.sqlite ".tables" || echo "Could not check tables"

# Debug: Show migration status
RUN php artisan migrate:status || echo "Could not check migration status"

# Run seeder only if migration worked
RUN php artisan db:seed --class=UserSeeder --force || echo "Seeder failed"

# Set permissions
RUN chown -R www-data:www-data /var/www/html \
    && chmod -R 755 /var/www/html/storage \
    && chmod 777 database/database.sqlite

# Configure Apache
RUN a2enmod rewrite

RUN echo '<VirtualHost *:80>\n\
    DocumentRoot /var/www/html/public\n\
    <Directory /var/www/html/public>\n\
        AllowOverride All\n\
        Require all granted\n\
    </Directory>\n\
</VirtualHost>' > /etc/apache2/sites-available/000-default.conf

EXPOSE 80

CMD ["apache2-foreground"]