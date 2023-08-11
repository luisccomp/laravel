#  Building current project and image
FROM php:8.2-cli as builder

WORKDIR /var/www

# Updating current linux distro
RUN apt update -y && \
    apt install -y libzip-dev

# Installing ZIP extension in order to install Composer locally
RUN docker-php-ext-install zip

# Installing composer
RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" && \
    php -r "if (hash_file('sha384', 'composer-setup.php') === 'e21205b207c3ff031906575712edab6f13eb0b361f2085f1f1237b7126d785e826a450292b6cfd1d64d92e6563bbde02') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;" && \
    php composer-setup.php && \
    php -r "unlink('composer-setup.php');"

COPY . .

RUN php composer.phar update


FROM php:8.2-fpm-alpine

WORKDIR /var/www

COPY --from=builder /var/www .

RUN rm -rf /var/www/html
RUN chown -R www-data:www-data /var/www
RUN ln -s /var/www/public html

EXPOSE 9000

CMD ["php-fpm"]
