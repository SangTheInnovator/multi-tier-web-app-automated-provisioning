#!/bin/bash

# Set EPEL repository
sudo yum install epel-release -y

# Install Dependencies
sudo yum update -y 
sudo yum install wget -y
cd /tmp/
dnf -y install centos-release-rabbitmq-38
dnf --enablerepo=centos-rabbitmq-38 -y install rabbitmq-server
systemctl enable --now rabbitmq-server

# Starting the firewall and allowing the port 5672 to access rabbitmq
firewall-cmd --add-port=5672/tcp
firewall-cmd --runtime-to-permanent

# Starting rabbitmq service
sudo systemctl start rabbitmq-server
sudo systemctl enable rabbitmq-server
sudo systemctl status rabbitmq-server

sudo sh -c 'echo "[{rabbit, [{loopback_users, []}]}]." > /etc/rabbitmq/rabbitmq.config'
sudo rabbitmqctl add_user test test
sudo rabbitmqctl set_user_tags test administrator

sudo systemctl restart rabbitmq-server