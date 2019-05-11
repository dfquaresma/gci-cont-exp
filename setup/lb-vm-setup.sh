#!/bin/bash

date
set -x

cd /home/ubuntu

# Get permissions
sudo su

# update stuffs
apt-get -y update # && apt-get upgrade -y

# Download and set haveged
apt-get -y install haveged
# should ensure that DAEMON_ARGS="-w 1024" is defined in /etc/default/haveged.
update-rc.d haveged defaults

# Install Nginx 
#add-apt-repository ppa:nginx/stable -y; apt-get update -y # Needed to install on ubuntu 14.
apt-get install nginx -y
wget http://www2.lsd.ufcg.edu.br/~davidfq/gci-setup/nginx.conf
mv nginx.conf /etc/nginx/

# Download YCSB
apt install -y maven
git clone https://github.com/dfquaresma/YCSB
cd YCSB
mvn -pl com.yahoo.ycsb:rest-binding -am clean package
apt install -y python