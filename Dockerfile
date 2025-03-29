# Use an official PHP-Apache base image
FROM php:8.2-apache
LABEL org.opencontainers.image.source=https://github.com/TihamiDev/GuesHouse-docker
# Set working directory
WORKDIR /var/www/html

# Install system dependencies and PHP extensions
RUN apt-get update && apt-get install -y \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    zip \
    unzip \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install -j$(nproc) gd pdo pdo_mysql mysqli

# Enable Apache rewrite module (useful for frameworks like Laravel)
RUN a2enmod rewrite

# Copy application files to the container
COPY . /var/www/html/

# Set permissions (optional, adjust as needed)
RUN chown -R www-data:www-data /var/www/html \
    && chmod -R 755 /var/www/html

# Install Composer (PHP dependency manager)
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Expose port 80
EXPOSE 80

# Start Apache in the foreground
CMD ["apache2-foreground"]