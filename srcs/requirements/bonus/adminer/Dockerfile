FROM alpine:3.18

# install prerequisites
# https://wordpress.com/support/php-environment/
RUN apk update && \
  	apk add --no-cache \
	curl \
	less \
	mariadb-client \
	php81 \
	php81-fpm \
	php81-common \
	php81-session \
	php81-iconv \
	php81-gd \
	php81-curl \
	php81-xml \
	php81-mysqli \
	php81-imap \
	php81-pdo \
	php81-pdo_mysql \
	php81-soap \
	php81-posix \
	php81-gettext \
	php81-ldap \
	php81-ctype \
	php81-dom \
	php81-simplexml

#RUN the adminer part, create html directory, move the adminer directory and add user

RUN \
	curl -L -O https://github.com/vrana/adminer/releases/download/v4.8.1/adminer-4.8.1.php && \
	mkdir -p /var/www/html && \
	mv ./adminer-4.8.1.php /var/www/html/index.php && \
	adduser -u 82 -D -S -G www-data www-data

COPY /conf/www.conf /etc/php81/php-fpm.d/www.conf

EXPOSE 9000
STOPSIGNAL SIGQUIT

CMD ["/usr/sbin/php-fpm81", "--nodaemonize"]
