# Dockerfile

# Use the official PHP image as a base
FROM php:8.2-fpm

# Set working directory
WORKDIR /var/www

# Install dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    libpng-dev \
    libjpeg62-turbo-dev \
    libfreetype6-dev \
    libzip-dev \
    zip \
    unzip \
    git \
    curl

# Install PHP extensions
RUN docker-php-ext-configure gd --with-freetype --with-jpeg && \
    docker-php-ext-install pdo pdo_mysql gd zip exif pcntl bcmath

# Install Composer
COPY --from=composer:2.6 /usr/bin/composer /usr/bin/composer

# Copy the application code
COPY . /var/www

# Set the proper permissions
RUN chown -R www-data:www-data /var/www

# Install application dependencies
RUN composer install --prefer-dist --no-scripts --no-dev --optimize-autoloader

# Expose port 9000 and start php-fpm server
EXPOSE 9000
CMD ["php-fpm"]
