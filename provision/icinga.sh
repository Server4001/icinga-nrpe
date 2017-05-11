#!/bin/bash

# Copy hosts file.
cp /vagrant/config/hosts/icinga.hosts /etc/hosts

# Install Icinga 2.
yum install -y https://packages.icinga.com/epel/6/release/noarch/icinga-rpm-release-6-1.el6.noarch.rpm
yum install -y icinga2 nagios-plugins-all vim-icinga2 icinga2-ido-mysql
service icinga2 start
chkconfig icinga2 on

MYSQL_ICINGA_PASSWORD=icinga

# Set up MySQL database for Icinga 2.
mysql -e "CREATE DATABASE IF NOT EXISTS icinga;"
mysql -e "GRANT SELECT, INSERT, UPDATE, DELETE, DROP, CREATE VIEW, INDEX, EXECUTE ON icinga.* TO 'icinga'@'localhost' IDENTIFIED BY '$MYSQL_ICINGA_PASSWORD';"

# Import Icinga 2 MySQL schema.
mysql icinga < /usr/share/icinga2-ido-mysql/schema/mysql.sql

# Enable external command pipe in Icinga 2.
icinga2 feature enable command
service icinga2 restart
usermod -a -G icingacmd nginx

# Install Icinga2 web and cli.
yum install -y icingaweb2 icingacli

# Configure nginx.
rm /etc/nginx/conf.d/default.conf
cp /vagrant/config/nginx/nginx.conf /etc/nginx/nginx.conf
cp /vagrant/config/nginx/icinga.conf /etc/nginx/conf.d/icinga.conf
service nginx reload

# Configure PHP-FPM.
rm /etc/php-fpm.d/www.conf
cp /vagrant/config/php/icinga-fpm-pool.conf /etc/php-fpm.d/icinga.conf
service php-fpm reload
