FROM php:8.2-cli

# Instalar dependências do sistema
RUN apt-get update && apt-get install -y \
    git unzip curl zip libzip-dev libicu-dev \
    && docker-php-ext-install intl zip pdo pdo_mysql

# Instalar Node.js
RUN curl -fsSL https://deb.nodesource.com/setup_18.x | bash - \
    && apt-get install -y nodejs

# Instalar Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Definir pasta
WORKDIR /app

# Copiar tudo
COPY . .

# Instalar PHP deps
RUN composer install --no-dev --optimize-autoloader

# Instalar frontend
RUN npm cache clean --force
RUN npm install --legacy-peer-deps
RUN npm run build

# Permissões (IMPORTANTE)
RUN chmod -R 777 storage bootstrap/cache

# Rodar Laravel
CMD php artisan serve --host=0.0.0.0 --port=$PORT
