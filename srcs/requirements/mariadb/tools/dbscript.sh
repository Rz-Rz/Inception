#!/bin/bash

service mysql start;

# Check if the database already exists
DB_CHECK=`mysql -uroot -p${DB_ROOT_PASS} -e "SHOW DATABASES LIKE '${DB_NAME}'" | grep ${DB_NAME}`

if [ "$DB_CHECK" == "${DB_NAME}" ]; then
	exec mysqld_safe
	echo "MariaDB database launched"
else
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
	# Keep the script running to prevent the container from stopping
	exec mysqld_safe
	#print status
	echo "MariaDB database and user were created successfully!"
fi

