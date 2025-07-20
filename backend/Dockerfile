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

# Create production .env file
RUN echo "APP_NAME=Brgy. Sikatuna Village IMS" > .env && \
    echo "APP_ENV=production" >> .env && \
    echo "APP_KEY=" >> .env && \
    echo "APP_DEBUG=false" >> .env && \
    echo "APP_URL=https://barangay-management-system-wc5e.onrender.com" >> .env && \
    echo "" >> .env && \
    echo "DB_CONNECTION=sqlite" >> .env && \
    echo "DB_DATABASE=database/database.sqlite" >> .env && \
    echo "" >> .env && \
    echo "SESSION_DRIVER=file" >> .env && \
    echo "SESSION_LIFETIME=120" >> .env && \
    echo "SESSION_ENCRYPT=false" >> .env && \
    echo "" >> .env && \
    echo "CACHE_STORE=file" >> .env && \
    echo "QUEUE_CONNECTION=sync" >> .env && \
    echo "" >> .env && \
    echo "LOG_CHANNEL=stderr" >> .env && \
    echo "LOG_LEVEL=error" >> .env

# Setup database
RUN touch database/database.sqlite && chmod 777 database/database.sqlite

ENV COMPOSER_ALLOW_SUPERUSER=1

RUN composer install --no-dev --optimize-autoloader

RUN php artisan key:generate --force

# Create users table
RUN sqlite3 database/database.sqlite "CREATE TABLE IF NOT EXISTS users (
    id TEXT PRIMARY KEY,
    username TEXT UNIQUE NOT NULL,
    email TEXT UNIQUE NOT NULL,
    password TEXT NOT NULL,
    first_name TEXT NOT NULL,
    last_name TEXT NOT NULL,
    middle_name TEXT,
    phone TEXT,
    role TEXT NOT NULL,
    department TEXT NOT NULL,
    position TEXT,
    employee_id TEXT,
    is_active INTEGER DEFAULT 1,
    is_verified INTEGER DEFAULT 0,
    notes TEXT,
    resident_id TEXT,
    created_by TEXT,
    updated_by TEXT,
    last_login_at TEXT,
    email_verified_at TEXT,
    created_at TEXT,
    updated_at TEXT,
    deleted_at TEXT
);"

# Create personal_access_tokens table
RUN sqlite3 database/database.sqlite "CREATE TABLE IF NOT EXISTS personal_access_tokens (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    tokenable_type TEXT NOT NULL,
    tokenable_id TEXT NOT NULL,
    name TEXT NOT NULL,
    token TEXT UNIQUE NOT NULL,
    abilities TEXT,
    last_used_at TEXT,
    expires_at TEXT,
    created_at TEXT,
    updated_at TEXT
);"

# Create admin user
RUN sqlite3 database/database.sqlite "INSERT OR IGNORE INTO users (
    id,
    username,
    email,
    password,
    first_name,
    last_name,
    role,
    department,
    is_active,
    is_verified,
    email_verified_at,
    created_at,
    updated_at
) VALUES (
    'admin-001',
    'admin',
    'admin@sikatuna.gov.ph',
    '\$2y\$12\$LQv3c1yqBwrf68.Js3k5We4T1FPfxK7zF7w/KlKLI8vLzN9bIE7VK',
    'Admin',
    'User',
    'SUPER_ADMIN',
    'ADMINISTRATION',
    1,
    1,
    datetime('now'),
    datetime('now'),
    datetime('now')
);"

# Set permissions
RUN chown -R www-data:www-data /var/www/html \
    && chmod -R 755 /var/www/html/storage \
    && chmod 777 database/database.sqlite

# Configure Apache
RUN a2enmod rewrite

RUN echo '<VirtualHost *:80>\nDocumentRoot /var/www/html/public\n<Directory /var/www/html/public>\nAllowOverride All\nRequire all granted\n</Directory>\n</VirtualHost>' > /etc/apache2/sites-available/000-default.conf

EXPOSE 80

CMD ["apache2-foreground"]