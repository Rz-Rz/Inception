#!/bin/bash
#set -eux

cd /var/www/html/wordpress

if ! wp core is-installed --allow-root; then
	wp config create	--allow-root --dbname=${SQL_DATABASE} \
		--dbuser=${SQL_USER} \
		--dbpass=${SQL_PASSWORD} \
		--dbhost=${SQL_HOST} \
		--url=https://${DOMAIN_NAME};

	wp core install	--allow-root \
		--url=https://${DOMAIN_NAME} \
		--title=${SITE_TITLE} \
		--admin_user=${ADMIN_USER} \
		--admin_password=${ADMIN_PASSWORD} \
		--admin_email=${ADMIN_EMAIL};

	# Update the 'home' and 'siteurl' options
	wp option update home https://${DOMAIN_NAME} --allow-root
	wp option update siteurl https://${DOMAIN_NAME} --allow-root

	wp user create		--allow-root \
		${USER1_LOGIN} ${USER1_MAIL} \
		--role=author \
		--user_pass=${USER1_PASS} ;

	wp cache flush --allow-root

# it provides an easy-to-use interface for creating custom contact forms and managing submissions, as well as supporting various anti-spam techniques
wp plugin install contact-form-7 --allow-root --activate

# set the site language to English
wp language core install en_US --allow-root --activate

# remove default themes and plugins
wp plugin delete hello --allow-root

# set the permalink structure
wp rewrite structure '/%postname%/' --allow-root

####### BONUS PART ################

## redis ##

wp config set WP_REDIS_HOST redis --allow-root #I put --allowroot because i am on the root user on my VM
wp config set WP_REDIS_PORT 6379 --raw --allow-root
wp config set WP_CACHE_KEY_SALT $DOMAIN_NAME --allow-root
#wp config set WP_REDIS_PASSWORD $REDIS_PASSWORD --allow-root
wp config set WP_REDIS_CLIENT phpredis --allow-root
wp plugin install redis-cache --activate --allow-root
wp plugin update --all --allow-root
wp redis enable --allow-root

###  end of redis part  ###

fi

if [ ! -d /run/php ]; then
	mkdir /run/php;
fi

# start the PHP FastCGI Process Manager (FPM) for PHP version 7.4 in the foreground
exec /usr/sbin/php-fpm8.2 -F -R
