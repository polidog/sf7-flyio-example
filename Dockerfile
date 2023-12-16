# syntax = docker/dockerfile:experimental

# Default to PHP 8.2, but we attempt to match
# the PHP version from the user (wherever `flyctl launch` is run)
# Valid version values are PHP 7.4+
ARG PHP_VERSION=8.2
ARG NODE_VERSION=18
FROM fideloper/fly-laravel:${PHP_VERSION} as base

# PHP_VERSION needs to be repeated here
# See https://docs.docker.com/engine/reference/builder/#understand-how-arg-and-from-interact
ARG PHP_VERSION

LABEL fly_launch_runtime="laravel"

# copy application code, skipping files based on .dockerignore
COPY . /var/www/html
COPY ./.fly/FlySymfonyRuntime.php /var/www/html/src/FlySymfonyRuntime.php

RUN composer install --optimize-autoloader --no-dev \
    && chown -R www-data:www-data /var/www/html \
    && cp .fly/entrypoint.sh /entrypoint \
    && chmod +x /entrypoint

EXPOSE 8080

ENTRYPOINT ["/entrypoint"]
