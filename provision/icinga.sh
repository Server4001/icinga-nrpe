#!/bin/bash

service ntpd start
chkconfig ntpd on

# Copy hosts file.
cp /vagrant/config/hosts/icinga.hosts /etc/hosts

# Install Icinga 2.
yum install -y https://packages.icinga.com/epel/6/release/noarch/icinga-rpm-release-6-1.el6.noarch.rpm
yum install -y icinga2 nagios-plugins-all vim-icinga2 icinga2-ido-mysql
service icinga2 start
chkconfig icinga2 on

MYSQL_ICINGA_PASSWORD=icinga
ICINGA_SCHEMA_EXISTS_FILE=/var/lib/mysql/.mysql-icinga-schema-created

if [ ! -f ${ICINGA_SCHEMA_EXISTS_FILE} ]; then
    # Set up MySQL database for Icinga 2.
    mysql -e "CREATE DATABASE IF NOT EXISTS icinga CHARACTER SET = 'utf8' COLLATE = 'utf8_general_ci';"
    mysql -e "GRANT SELECT, INSERT, UPDATE, DELETE, DROP, CREATE VIEW, INDEX, EXECUTE ON icinga.* TO 'icinga'@'localhost' IDENTIFIED BY '$MYSQL_ICINGA_PASSWORD';"
    mysql -e "CREATE DATABASE IF NOT EXISTS icingaweb CHARACTER SET = 'utf8' COLLATE = 'utf8_general_ci';"
    mysql -e "GRANT ALTER, CREATE, DELETE, DROP, INDEX, INSERT, LOCK TABLES, SELECT, UPDATE, REFERENCES, CREATE TEMPORARY TABLES, EXECUTE, CREATE VIEW, SHOW VIEW, CREATE ROUTINE, ALTER ROUTINE, EVENT, TRIGGER on icingaweb.* TO 'icinga'@'localhost';"
    mysql -e "FLUSH PRIVILEGES;"

    # Import Icinga 2 MySQL schema.
    mysql icinga < /usr/share/icinga2-ido-mysql/schema/mysql.sql

    touch ${ICINGA_SCHEMA_EXISTS_FILE}
fi

# Enable external command pipe in Icinga 2.
icinga2 feature enable command
service icinga2 restart

# Install Icinga2 web and cli.
yum install -y icingaweb2 icingacli

# Change log permissions.
chown nginx:nginx /var/log/php-fpm/
chmod 0775 /var/log/php-fpm/
chmod -R 0644 /var/log/php-fpm/*.log
chmod 0644 /var/log/mysqld.log
chmod -R 0644 /var/log/nginx/*.log

# Configure PHP
yum install -y php70w-ldap
chown nginx: /var/lib/php/session /var/lib/php/wsdlcache
cp /vagrant/config/php/php.ini /etc/php.ini
rm -f /etc/php.d/json.ini

NGINX_ICINGACMD_GROUP=$(groups nginx | grep icingacmd | wc -l)
NGINX_ICINGAWEB_GROUP=$(groups nginx | grep icingaweb2 | wc -l)

# Add nginx user to Icinga 2 groups. Must RESTART nginx and PHP-FPM afterwards.
if [ ${NGINX_ICINGACMD_GROUP} -lt 1 ]; then
    usermod -a -G icingacmd nginx
fi
if [ ${NGINX_ICINGAWEB_GROUP} -lt 1 ]; then
    usermod -a -G icingaweb2 nginx
fi

# Configure nginx.
rm -f /etc/nginx/conf.d/default.conf
cp /vagrant/config/nginx/nginx.conf /etc/nginx/nginx.conf
cp /vagrant/config/nginx/icinga.conf /etc/nginx/conf.d/icinga.conf
service nginx restart

# Configure PHP-FPM.
rm -f /etc/php-fpm.d/www.conf
cp /vagrant/config/php/icinga-fpm-pool.conf /etc/php-fpm.d/icinga.conf
service php-fpm restart
