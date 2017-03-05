#!/bin/bash

#Exit immediately if a command exits with a non-zero status
set -e

echo "Installing EPEL repository..."
sudo yum -y install https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm

echo "Disabling EPEL repository globally..."
sudo sed -i -e "s/^enabled=1/enabled=0/" /etc/yum.repos.d/epel.repo

echo "Installing Ansible and deps..."
sudo yum -y --enablerepo=epel install ansible pyOpenSSL
