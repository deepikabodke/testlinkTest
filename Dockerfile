FROM php:7.2-apache


RUN apt update -y && apt upgrade -y
RUN docker-php-ext-install mysqli && docker-php-ext-enable mysqli

RUN apt-get update -y && apt-get install -y libwebp-dev libjpeg62-turbo-dev libpng-dev libxpm-dev \
    libfreetype6-dev
RUN apt-get update && \
    apt-get install -y \
        zlib1g-dev 

RUN docker-php-ext-install mbstring

RUN apt-get install -y libzip-dev
RUN docker-php-ext-install zip

RUN docker-php-ext-configure gd --with-gd --with-webp-dir --with-jpeg-dir \
    --with-png-dir --with-zlib-dir --with-xpm-dir --with-freetype-dir \
    --with-gd

RUN docker-php-ext-install gd


EXPOSE 8080
EXPOSE 80

WORKDIR /var/www/html
COPY . ./

# change owner of all files so apache can write to it
RUN chown -R www-data *


# update apache port config (because TestLink needs to use 8080)
RUN cat ./apache/ports.conf > /etc/apache2/ports.conf

# create required folders and change owner
RUN mkdir -p /var/testlink/logs/ mkdir -p /var/testlink/upload_area/ && chown -R www-data /var/testlink/

RUN chown -R www-data /var/testlink/logs/ && chown -R www-data /var/www/html/gui/templates_c