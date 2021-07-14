FROM php:7.4-apache

# RUN apt-get update && apt-get install -y libcurl

RUN docker-php-ext-install pdo_mysql

COPY ./ /var/php

EXPOSE 8080

CMD ["php", "-c", "/var/php", "-f", "/var/php/job-sleep.php"]