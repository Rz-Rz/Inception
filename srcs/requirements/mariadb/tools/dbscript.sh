#!/bin/bash

if [ -d "/var/lib/mysql/$SQL_DATABASE" ]
then
	echo "Database already exists"
else
service mysql start;

	# Wait for the database service to start up
	echo "Waiting for MariaDB to start up..."
	sleep 10  # Wait for 10 seconds (or more if needed)
	# log into MariaDB as root and create database and the user
	# Since the root user doesn't have a password yet, we don't need to provide one
	mysql -uroot -e "CREATE DATABASE IF NOT EXISTS \`${SQL_DATABASE}\`;"
	mysql -uroot -e "CREATE USER IF NOT EXISTS \`${SQL_USER}\`@'localhost' IDENTIFIED BY '${SQL_PASSWORD}';"
	mysql -uroot -e "GRANT ALL PRIVILEGES ON \`${SQL_DATABASE}\`.* TO \`${SQL_USER}\`@'%' IDENTIFIED BY '${SQL_PASSWORD}';"
	mysql -uroot -e "FLUSH PRIVILEGES;"
	mysql -uroot -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '${SQL_ROOT_PASSWORD}';"  # Now set the root password
	mysqladmin -u root -p${SQL_ROOT_PASSWORD} shutdown
	echo "MariaDB database and user were created successfully!"
fi
# Keep the script running to prevent the container from stopping
	exec mysqld_safe
	#Running mysqld_sage

