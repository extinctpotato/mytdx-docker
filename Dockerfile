FROM php:7.2-alpine

COPY entrypoint.sh /entrypoint.sh

RUN apk add git 

WORKDIR /var/www/html

RUN git clone https://github.com/MoonCactus/myTDX

WORKDIR /var/www/html/myTDX

RUN rm -rf db && mv db_sample db

RUN apk del git

CMD ["/entrypoint.sh"]

