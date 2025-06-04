# Use PHP 8.1 CLI image as the base
FROM php:8.1

# Install system dependencies
RUN apt-get update && apt-get install -y \
    libpq-dev \
    zip \
    unzip \
    git \
    && docker-php-ext-install pdo pdo_pgsql

# Install Composer globally
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Set working directory
WORKDIR /var/www/html

# Copy application files
COPY . .

# Set permissions
RUN chown -R www-data:www-data /var/www/html && \
    chmod -R 755 /var/www/html

# Install PHP dependencies
RUN composer update --no-dev && composer install --no-dev --optimize-autoloader

# Expose HTTP port
EXPOSE 9000

# Start built-in PHP web server
CMD ["php", "-S", "0.0.0.0:9000", "-t", "web"]
