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

# Setup database
RUN touch database/database.sqlite && chmod 777 database/database.sqlite

ENV COMPOSER_ALLOW_SUPERUSER=1

RUN composer install --no-dev --optimize-autoloader

RUN php artisan key:generate --force || true

# Create a simple SQL script file
RUN echo 'CREATE TABLE IF NOT EXISTS users (' > create_users.sql && \
    echo 'id TEXT PRIMARY KEY,' >> create_users.sql && \
    echo 'username TEXT UNIQUE NOT NULL,' >> create_users.sql && \
    echo 'email TEXT UNIQUE NOT NULL,' >> create_users.sql && \
    echo 'password TEXT NOT NULL,' >> create_users.sql && \
    echo 'first_name TEXT NOT NULL,' >> create_users.sql && \
    echo 'last_name TEXT NOT NULL,' >> create_users.sql && \
    echo 'middle_name TEXT,' >> create_users.sql && \
    echo 'phone TEXT,' >> create_users.sql && \
    echo 'role TEXT NOT NULL,' >> create_users.sql && \
    echo 'department TEXT NOT NULL,' >> create_users.sql && \
    echo 'position TEXT,' >> create_users.sql && \
    echo 'employee_id TEXT,' >> create_users.sql && \
    echo 'is_active INTEGER DEFAULT 1,' >> create_users.sql && \
    echo 'is_verified INTEGER DEFAULT 0,' >> create_users.sql && \
    echo 'notes TEXT,' >> create_users.sql && \
    echo 'resident_id TEXT,' >> create_users.sql && \
    echo 'created_by TEXT,' >> create_users.sql && \
    echo 'updated_by TEXT,' >> create_users.sql && \
    echo 'last_login_at TEXT,' >> create_users.sql && \
    echo 'email_verified_at TEXT,' >> create_users.sql && \
    echo 'created_at TEXT DEFAULT (datetime("now")),' >> create_users.sql && \
    echo 'updated_at TEXT DEFAULT (datetime("now")),' >> create_users.sql && \
    echo 'deleted_at TEXT' >> create_users.sql && \
    echo ');' >> create_users.sql

# Execute the SQL script
RUN sqlite3 database/database.sqlite < create_users.sql && rm create_users.sql

# Create personal_access_tokens table
RUN sqlite3 database/database.sqlite 'CREATE TABLE IF NOT EXISTS personal_access_tokens (id INTEGER PRIMARY KEY AUTOINCREMENT, tokenable_type TEXT NOT NULL, tokenable_id TEXT NOT NULL, name TEXT NOT NULL, token TEXT UNIQUE NOT NULL, abilities TEXT, last_used_at TEXT, expires_at TEXT, created_at TEXT DEFAULT (datetime("now")), updated_at TEXT DEFAULT (datetime("now")));'

# Create admin user with bcrypt hash for "password123"
RUN sqlite3 database/database.sqlite "INSERT OR IGNORE INTO users (id, username, email, password, first_name, last_name, role, department, is_active, is_verified, email_verified_at, created_at, updated_at) VALUES ('admin-001', 'admin', 'admin@sikatuna.gov.ph', '\$2y\$12\$LQv3c1yqBwrf68.Js3k5We4T1FPfxK7zF7w/KlKLI8vLzN9bIE7VK', 'Admin', 'User', 'SUPER_ADMIN', 'ADMINISTRATION', 1, 1, datetime('now'), datetime('now'), datetime('now'));"

# Set permissions
RUN chown -R www-data:www-data /var/www/html \
    && chmod -R 755 /var/www/html/storage \
    && chmod 777 database/database.sqlite

# Configure Apache
RUN a2enmod rewrite

RUN echo '<VirtualHost *:80>\nDocumentRoot /var/www/html/public\n<Directory /var/www/html/public>\nAllowOverride All\nRequire all granted\n</Directory>\n</VirtualHost>' > /etc/apache2/sites-available/000-default.conf

EXPOSE 80

CMD ["apache2-foreground"]