#!/bin/bash

date
set -x

# Update repository
cd /home/ubuntu/socc19
git pull
cd /home/ubuntu/

# Update containers images
cd /home/ubuntu/socc19/containers/go-gci
gofmt -s -w main; gofmt -s -w function/handler.go
docker build -t image-gogci . 
cd /home/ubuntu/socc19/containers/go-nogci
gofmt -s -w main; gofmt -s -w function/handler.go
docker build -t image-gonogci . 
cd /home/ubuntu/socc19/containers/go-zero
gofmt -s -w main; gofmt -s -w function/handler.go
docker build -t image-gozero . 
cd /home/ubuntu/