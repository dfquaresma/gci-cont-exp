#!/bin/bash
date
set -x

# To avoid execution without passing environment variables
if [[ (-z "$ID_RSA_PATH") || (-z "$EXPID") ]];
then
  echo -e "${RED}THERE ARE VARIABLES MISSING: workload.sh${NC}"
  exit
fi

ssh-keygen -f "/home/ubuntu/.ssh/known_hosts" -R 10.11.4.113
ssh -i ${ID_RSA_PATH}  ubuntu@10.11.4.113 -o StrictHostKeyChecking=no "sudo rm /var/log/nginx/*.log; sudo service nginx restart; sudo rm -rf /home/ubuntu/*-YCSB-std*-e*.log"
sleep 5
ssh -i ${ID_RSA_PATH}  ubuntu@10.11.4.113 -o StrictHostKeyChecking=no "cd /home/ubuntu/YCSB/; ./bin/ycsb run rest -s -P workloads/rest_workload >/home/ubuntu/${CONTAINER_TAG}-YCSB-stdout-e${EXPID}.log 2>/home/ubuntu/${CONTAINER_TAG}-YCSB-stderr-e${EXPID}.log"
