#!/bin/bash

# Install ntpd.
yum install -y ntp
service ntpd start
chkconfig ntpd on

# Copy hosts file.
cp /vagrant/config/hosts/web.hosts /etc/hosts
sed -i "s/dev.web.loc/`hostname`/" /etc/hosts

# Application health check.
HEALTH_CHECK_FILE=/var/www/html/health.php
cp /vagrant/config/php/health.php ${HEALTH_CHECK_FILE}
chown vagrant:vagrant ${HEALTH_CHECK_FILE}
chmod 0644 ${HEALTH_CHECK_FILE}

# Install NRPE.
yum install -y nagios-plugins nagios-plugins-procs nagios-plugins-load nagios-plugins-disk nrpe

# Configure NRPE.
cp /vagrant/config/nrpe/nrpe.cfg /etc/nagios/nrpe.cfg

# Start NRPE.
service nrpe start
chkconfig nrpe on
