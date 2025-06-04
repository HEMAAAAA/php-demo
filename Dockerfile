# Use PHP 8.1 FPM image as the base
FROM php:8.1-fpm

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
# Set permissions for the application files
RUN chown -R www-data:www-data /var/www/html && \
    chmod -R 755 /var/www/html

# Generate composer.lock file and install dependencies
RUN composer update --no-dev && composer install --no-dev --optimize-autoloader

# Expose port 9000 for PHP-FPM
EXPOSE 9000

# Start PHP-FPM server
CMD ["php-fpm"]