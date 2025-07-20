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
    libzip-dev && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Install PHP extensions
RUN docker-php-ext-install pdo pdo_sqlite mbstring exif pcntl bcmath gd zip

# Get latest Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Set working directory
WORKDIR /var/www/html

# Copy application
COPY . .

# Remove problematic files
RUN rm -f database/migrations/2025_07_11_000000_remove_house_number_from_households_table.php || true

# Create basic .env first
RUN echo "APP_NAME=Laravel" > .env && \
    echo "APP_ENV=production" >> .env && \
    echo "APP_KEY=base64:placeholder" >> .env && \
    echo "APP_DEBUG=false" >> .env && \
    echo "DB_CONNECTION=sqlite" >> .env && \
    echo "DB_DATABASE=database/database.sqlite" >> .env && \
    echo "SESSION_DRIVER=file" >> .env && \
    echo "CACHE_STORE=file" >> .env

# Setup database
RUN touch database/database.sqlite && chmod 777 database/database.sqlite

ENV COMPOSER_ALLOW_SUPERUSER=1

# Install composer dependencies
RUN composer install --no-dev --no-scripts --no-autoloader && \
    composer dump-autoload --optimize --no-dev

# Generate app key
RUN php artisan key:generate --force

# Update .env with production settings
RUN sed -i 's/APP_NAME=Laravel/APP_NAME="Brgy. Sikatuna Village IMS"/' .env && \
    sed -i 's|APP_KEY=base64:placeholder|APP_KEY=base64:3gGQ4QLVbL3hl0JBcLZBUGWte2eOuKilirRHIPuOOFM=|' .env

# Package discovery
RUN php artisan package:discover --ansi || echo "Package discovery failed"

# Try migrations first
RUN php artisan migrate --force || echo "Migrations failed, creating tables manually"

# Create users table manually
RUN printf '%s\n' \
    'CREATE TABLE IF NOT EXISTS users (' \
    'id TEXT PRIMARY KEY,' \
    'username TEXT UNIQUE NOT NULL,' \
    'email TEXT UNIQUE NOT NULL,' \
    'password TEXT NOT NULL,' \
    'first_name TEXT NOT NULL,' \
    'last_name TEXT NOT NULL,' \
    'middle_name TEXT,' \
    'phone TEXT,' \
    'role TEXT NOT NULL,' \
    'department TEXT NOT NULL,' \
    'position TEXT,' \
    'employee_id TEXT,' \
    'is_active INTEGER DEFAULT 1,' \
    'is_verified INTEGER DEFAULT 0,' \
    'notes TEXT,' \
    'resident_id TEXT,' \
    'created_by TEXT,' \
    'updated_by TEXT,' \
    'last_login_at TEXT,' \
    'email_verified_at TEXT,' \
    'created_at TEXT,' \
    'updated_at TEXT,' \
    'deleted_at TEXT' \
    ');' > schema.sql && \
    sqlite3 database/database.sqlite < schema.sql && \
    rm schema.sql

# Create personal_access_tokens table
RUN sqlite3 database/database.sqlite 'CREATE TABLE IF NOT EXISTS personal_access_tokens (id INTEGER PRIMARY KEY AUTOINCREMENT, tokenable_type TEXT, tokenable_id TEXT, name TEXT, token TEXT UNIQUE, abilities TEXT, last_used_at TEXT, expires_at TEXT, created_at TEXT, updated_at TEXT);'

# Create admin user using PHP script (avoids escaping issues)
RUN echo '<?php' > create_admin.php && \
    echo 'require_once "vendor/autoload.php";' >> create_admin.php && \
    echo '$app = require_once "bootstrap/app.php";' >> create_admin.php && \
    echo '$app->make("Illuminate\Contracts\Console\Kernel")->bootstrap();' >> create_admin.php && \
    echo 'use App\Models\User;' >> create_admin.php && \
    echo 'try {' >> create_admin.php && \
    echo '  User::create([' >> create_admin.php && \
    echo '    "id" => "admin-001",' >> create_admin.php && \
    echo '    "username" => "admin",' >> create_admin.php && \
    echo '    "email" => "admin@sikatuna.gov.ph",' >> create_admin.php && \
    echo '    "password" => "password123",' >> create_admin.php && \
    echo '    "first_name" => "Admin",' >> create_admin.php && \
    echo '    "last_name" => "User",' >> create_admin.php && \
    echo '    "role" => "SUPER_ADMIN",' >> create_admin.php && \
    echo '    "department" => "ADMINISTRATION",' >> create_admin.php && \
    echo '    "is_active" => true,' >> create_admin.php && \
    echo '    "is_verified" => true,' >> create_admin.php && \
    echo '    "email_verified_at" => now()' >> create_admin.php && \
    echo '  ]);' >> create_admin.php && \
    echo '  echo "Admin user created successfully";' >> create_admin.php && \
    echo '} catch (Exception $e) {' >> create_admin.php && \
    echo '  echo "Error: " . $e->getMessage();' >> create_admin.php && \
    echo '}' >> create_admin.php && \
    php create_admin.php && \
    rm create_admin.php

# Set permissions
RUN chown -R www-data:www-data /var/www/html && \
    chmod -R 755 /var/www/html/storage && \
    chmod 777 database/database.sqlite

# Configure Apache
RUN a2enmod rewrite && \
    echo '<VirtualHost *:80>\nDocumentRoot /var/www/html/public\n<Directory /var/www/html/public>\nAllowOverride All\nRequire all granted\n</Directory>\n</VirtualHost>' > /etc/apache2/sites-available/000-default.conf

EXPOSE 80

CMD ["apache2-foreground"]