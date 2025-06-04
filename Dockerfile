# Use PHP CLI base image for built-in server
FROM php:8.1-cli

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

# Install dependencies
RUN composer update --no-dev && composer install --no-dev --optimize-autoloader

# Expose HTTP port
EXPOSE 80

# Start PHP's built-in server serving Yii2's public folder
CMD ["php", "-S", "0.0.0.0:80", "-t", "web"]
