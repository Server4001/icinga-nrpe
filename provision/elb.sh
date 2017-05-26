#!/bin/bash

# Copy hosts file.
cp /vagrant/config/hosts/elb.hosts /etc/hosts

# Add EPEL repo.
rpm -Uvh https://dl.fedoraproject.org/pub/epel/epel-release-latest-6.noarch.rpm

# Install haproxy, etc.
yum install -y haproxy socat bash-completion

service haproxy start
chkconfig haproxy on

cp /vagrant/config/haproxy/haproxy.cfg /etc/haproxy/haproxy.cfg
service haproxy restart
