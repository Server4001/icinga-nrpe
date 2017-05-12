#!/bin/bash

# Copy hosts file.
cp /vagrant/config/hosts/web.hosts /etc/hosts
sed -i "s/dev.web.loc/`hostname`/" /etc/hosts

# Install NRPE.
yum install -y nagios-plugins nrpe

# Configure NRPE.
cp /vagrant/config/nrpe/nrpe.cfg /etc/nagios/nrpe.cfg

# Start NRPE.
service nrpe start
chkconfig nrpe on
