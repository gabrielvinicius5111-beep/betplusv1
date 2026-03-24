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

# Instalar node
RUN curl -fsSL https://deb.nodesource.com/setup_18.x | bash - \
    && apt-get install -y nodejs

RUN npm install && npm run build

# Rodar servidor
CMD php artisan serve --host=0.0.0.0 --port=$PORT
