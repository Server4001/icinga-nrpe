#!/bin/bash

# Disable firewall.
service iptables stop
service ip6tables stop
chkconfig iptables off
chkconfig ip6tables off

# Copy hosts file.
cp /vagrant/config/hosts/icinga.hosts /etc/hosts

# Install pre-reqs.
rpm -Uvh https://dl.fedoraproject.org/pub/epel/epel-release-latest-6.noarch.rpm
yum install -y bash-completion git vim tree yum-utils

# Install Icinga 2.
yum install -y https://packages.icinga.com/epel/6/release/noarch/icinga-rpm-release-6-1.el6.noarch.rpm
yum install -y icinga2 nagios-plugins-all vim-icinga2
service icinga2 start
chkconfig icinga2 on

# Install MySQL 5.7.
yum install -y http://dev.mysql.com/get/mysql-community-release-el6-5.noarch.rpm
yum-config-manager --disable mysql56-community
yum-config-manager --enable mysql57-community-dmr
yum install -y mysql-community-server-5.7.13

MYSQL_ROOT_PASSWORD=password
MYSQL_ICINGA_PASSWORD=icinga
MYSQL_LOG_DIR=/var/log/mysql

# Configure MySQL 5.7.
mkdir ${MYSQL_LOG_DIR}
chmod 0755 ${MYSQL_LOG_DIR}
chown mysql: ${MYSQL_LOG_DIR}
mysqld --initialize-insecure
chown -R mysql: /var/lib/mysql
cp /vagrant/config/mysql/my.cnf /etc/my.cnf
chmod 0644 /etc/my.cnf
chown mysql: /etc/my.cnf
service mysqld start
chkconfig mysqld on

if [ ! -f /var/lib/mysql/.mysql-root-password-has-been-created ]; then
    # Create the mysql root user password.
    mysqladmin -u root password ${MYSQL_ROOT_PASSWORD}
    touch /var/lib/mysql/.mysql-root-password-has-been-created
fi

# Set .my.cnf for root and vagrant users.
cp /vagrant/config/mysql/.my.cnf /root/.my.cnf
cp /vagrant/config/mysql/.my.cnf /home/vagrant/.my.cnf
chmod 0600 /root/.my.cnf
chmod 0600 /home/vagrant/.my.cnf
chown vagrant: /home/vagrant/.my.cnf

# Ensure root user login from 127.0.0.1 works.
mysql -e "GRANT ALL PRIVILEGES ON *.* TO 'root'@'127.0.0.1' identified by '$MYSQL_ROOT_PASSWORD';"

# Flush MySQL privileges.
mysql -e "FLUSH PRIVILEGES;"

service mysqld restart

# Install IDO modules for MySQL.
yum install -y icinga2-ido-mysql

# Set up MySQL database for Icinga 2.
mysql -e "CREATE DATABASE IF NOT EXISTS icinga;"
mysql -e "GRANT SELECT, INSERT, UPDATE, DELETE, DROP, CREATE VIEW, INDEX, EXECUTE ON icinga.* TO 'icinga'@'localhost' IDENTIFIED BY '$MYSQL_ICINGA_PASSWORD';"

# Import Icinga 2 MySQL schema.
mysql icinga < /usr/share/icinga2-ido-mysql/schema/mysql.sql

# TODO : REMOVE AFTER CONFIRMING IT HAS ALREADY BEEN ADDED (check using `icinga2 feature list`):
# icinga2 feature enable ido-mysql

# Install nginx.
yum install -y nginx
service nginx start
chkconfig nginx on

# Configure nginx.
rm /etc/nginx/conf.d/default.conf /etc/nginx/conf.d/ssl.conf /etc/nginx/conf.d/virtual.conf
cp /vagrant/config/nginx/nginx.conf /etc/nginx/nginx.conf
service nginx reload

# Enable external command pipe in Icinga 2.
icinga2 feature enable command
service icinga2 restart
usermod -a -G icingacmd nginx

# Install Icinga2 web and cli.
yum install -y icingaweb2 icingacli


# Bash aliases.
cp /vagrant/config/bash/root.bashrc /root/.bashrc
cp /vagrant/config/bash/vagrant.bashrc /home/vagrant/.bashrc
chown vagrant: /home/vagrant/.bashrc
