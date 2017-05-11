#!/bin/bash

# Disable firewall.
service iptables stop
service ip6tables stop
chkconfig iptables off
chkconfig ip6tables off

# Install pre-reqs.
rpm -Uvh https://dl.fedoraproject.org/pub/epel/epel-release-latest-6.noarch.rpm
yum install -y bash-completion git vim tree

# Install Icinga2.
yum install -y https://packages.icinga.com/epel/6/release/noarch/icinga-rpm-release-6-1.el6.noarch.rpm
yum install -y nagios-plugins-all
service icinga2 start
chkconfig icinga2 on

# Copy hosts file.
cp /vagrant/config/hosts/icinga.hosts /etc/hosts
chmod 0644 /etc/hosts

icinga2 feature list
