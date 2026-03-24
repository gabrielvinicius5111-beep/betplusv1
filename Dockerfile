FROM php:8.2-fpm

# Instalar dependências do sistema
RUN apt-get update && apt-get install -y \
    zip unzip git curl libzip-dev libicu-dev \
    && docker-php-ext-install intl zip pdo pdo_mysql

# Instalar composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Copiar projeto
WORKDIR /app
COPY . .

# Instalar dependências
RUN composer install --no-dev --optimize-autoloader

# Rodar servidor
CMD php artisan serve --host=0.0.0.0 --port=$PORT
