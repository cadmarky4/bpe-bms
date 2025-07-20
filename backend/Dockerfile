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

# Skip user migration but run others for residents, appointments, etc.
RUN mv database/migrations/*create_users_table.php database/migrations/create_users_table.php.skip || true && \
    rm -f database/migrations/2025_07_11_000000_remove_house_number_from_households_table.php && \
    php artisan migrate --force || echo "Some migrations failed"

# Create users table manually with UUID support
RUN sqlite3 database/database.sqlite "CREATE TABLE users (
    id TEXT PRIMARY KEY,
    first_name TEXT NOT NULL,
    last_name TEXT NOT NULL,
    middle_name TEXT,
    email TEXT UNIQUE NOT NULL,
    phone TEXT,
    username TEXT UNIQUE NOT NULL,
    email_verified_at TEXT,
    password TEXT NOT NULL,
    role TEXT NOT NULL,
    department TEXT NOT NULL,
    position TEXT,
    employee_id TEXT,
    is_active INTEGER DEFAULT 1,
    is_verified INTEGER DEFAULT 0,
    last_login_at TEXT,
    notes TEXT,
    remember_token TEXT,
    created_by TEXT,
    updated_by TEXT,
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
RUN sqlite3 database/database.sqlite "INSERT INTO users (
    id, first_name, last_name, email, phone, username, password, 
    role, department, position, employee_id, is_active, is_verified,
    email_verified_at, created_at, updated_at
) VALUES (
    'admin-001',
    'Admin', 'User', 'admin@sikatuna.gov.ph', '+639171234567',
    'admin', '\$2y\$12\$/iYJFd3zTUwMKUV/q8swxOc0GZ/q04dAj8gn8IXJxCN1NMFPHO4Va',
    'SUPER_ADMIN', 'ADMINISTRATION', 'System Administrator', 'EMP-001',
    1, 1, datetime('now'), datetime('now'), datetime('now')
);"

# Verify what tables were created
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