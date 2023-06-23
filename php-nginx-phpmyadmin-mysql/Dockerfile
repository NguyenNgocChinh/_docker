# Set master image
FROM php:8.1-fpm

# Set working directory
WORKDIR /var/www/html

# Install Additional dependencies
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y \
        curl \
        libpng-dev \
        libonig-dev \
        libxml2-dev \
        zip \
        unzip \
        git \
        libzip-dev \
        supervisor \
        && docker-php-ext-install pcntl \
        && apt-get clean && rm -rf /var/lib/apt/lists/* \
        && curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Install specific version of Node.js and npm
RUN curl -sL https://deb.nodesource.com/setup_19.x | bash -
RUN apt-get update && apt-get install -y \
  nodejs=19.*

# Install redis
RUN pecl install redis && docker-php-ext-enable redis

# Install PHP extensions
RUN docker-php-ext-install pdo_mysql mbstring exif pcntl bcmath gd zip

# Set timezone
RUN ln -sf /usr/share/zoneinfo/Asia/Ho_Chi_Minh /etc/localtime

# Copy the rest of the application code
COPY . /var/www/html
COPY .docker/supervisord.conf /etc/supervisord.conf
COPY .docker/supervisor.d /etc/supervisor.d

# Create a new system user
RUN useradd -ms /bin/bash deployer

RUN chown -R deployer:deployer . /var/www/html && \
    chmod -R 755 /var/www/html && \
    chmod -R 755 /etc/supervisord.conf && \
    chmod -R 755 /etc/supervisor.d && \
    cd /var/www/html

# Use the default production configuration for PHP-FPM ($PHP_INI_DIR variable already set by the default image)
RUN mv "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini"

# ENV ENABLE_CRONTAB 1
# ENV ENABLE_HORIZON 1

# RUN mv -f /etc/supervisor.d/cron.conf.default /etc/supervisor.d/cron.conf
# RUN mv -f /etc/supervisor.d/worker.conf.default /etc/supervisor.d/worker.conf
# RUN mv -f /etc/supervisor.d/horizon.conf.default /etc/supervisor.d/horizon.conf

# RUN mkdir -p /etc/crontabs
# RUN echo "* * * * * php /var/www/html/artisan schedule:run >> /dev/null 2>&1" >> /etc/crontabs/www-data

ENTRYPOINT ["sh", "/var/www/html/.docker/docker-entrypoint.sh"]

# Set the user for subsequent commands
USER deployer

# CMD ["sh", ".docker/docker-command.sh"]
CMD ["php-fpm"]

# Expose port APP_PORT for PHP-FPM (using nginx)
EXPOSE 9000 