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

# Download Docker-CE
apt -y install docker.io
systemctl start docker
systemctl enable docker

# Download experiment's repository
git clone https://github.com/dfquaresma/socc19
cd /home/ubuntu/socc19/containers/go-gci
docker build -t image-gogci . 
cd /home/ubuntu/socc19/containers/go-nogci
docker build -t image-gonogci . 
cd /home/ubuntu/socc19/containers/go-zero
docker build -t image-gozero . 
