FROM php:8.0-apache AS builder
WORKDIR /var/www/html
COPY . .

FROM php:8.0-apache
WORKDIR /var/www/html
COPY --from=builder /var/www/html .
EXPOSE 80