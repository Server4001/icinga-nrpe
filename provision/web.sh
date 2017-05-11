#!/bin/bash

# Copy hosts file.
cp /vagrant/config/hosts/web.hosts /etc/hosts
sed -i "s/dev.web.loc/`hostname`/" /etc/hosts
