#!/bin/bash
date
set -x

scp -i id_rsa -o StrictHostKeyChecking=no ubuntu@10.11.4.113:"/var/log/nginx/*.log" $RESULTS_PATH
