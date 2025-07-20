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

# Install PHP extensions (including zip)
RUN docker-php-ext-install pdo pdo_sqlite mbstring exif pcntl bcmath gd zip

# Get latest Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Set working directory
WORKDIR /var/www/html

# Copy existing application directory contents
COPY . .

# Create SQLite database file with proper permissions
RUN touch database/database.sqlite && chmod 777 database/database.sqlite

# Set composer environment variable
ENV COMPOSER_ALLOW_SUPERUSER=1

# Install dependencies
RUN composer install --no-dev --optimize-autoloader

# Generate application key if not set
RUN php artisan key:generate --force || true

# Run migrations
RUN php artisan migrate --force || echo "Migration failed"

# Create a simple seeder script for admin user
RUN echo "<?php\n\
use App\Models\User;\n\
try {\n\
    User::firstOrCreate(\n\
        ['username' => 'admin'],\n\
        [\n\
            'username' => 'admin',\n\
            'email' => 'admin@sikatuna.gov.ph',\n\
            'password' => 'admin123',\n\
            'first_name' => 'System',\n\
            'last_name' => 'Administrator',\n\
            'role' => 'SUPER_ADMIN',\n\
            'department' => 'ADMINISTRATION',\n\
            'is_active' => true,\n\
            'is_verified' => true\n\
        ]\n\
    );\n\
    echo 'Admin user created successfully';\n\
} catch (Exception \$e) {\n\
    echo 'Error: ' . \$e->getMessage();\n\
}" > create_admin.php && php create_admin.php && rm create_admin.php

# Change ownership and permissions
RUN chown -R www-data:www-data /var/www/html \
    && chmod -R 755 /var/www/html/storage \
    && chmod 777 database/database.sqlite

# Enable Apache mod_rewrite
RUN a2enmod rewrite

# Copy Apache configuration
RUN echo '<VirtualHost *:80>\n\
    DocumentRoot /var/www/html/public\n\
    <Directory /var/www/html/public>\n\
        AllowOverride All\n\
        Require all granted\n\
    </Directory>\n\
</VirtualHost>' > /etc/apache2/sites-available/000-default.conf

EXPOSE 80

CMD ["apache2-foreground"]