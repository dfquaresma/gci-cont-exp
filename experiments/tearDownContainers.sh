#!/bin/bash
date
set -x

LAST_IP_NUMBER="198 218 231 242"
COMMAND="sudo docker kill container-${CONTAINER_TAG}"
for i in ${LAST_IP_NUMBER}
do
	ssh-keygen -f "/home/ubuntu/.ssh/known_hosts" -R 10.11.4.${i}
	ssh -i ${ID_RSA_PATH}  ubuntu@10.11.4.${i} -o StrictHostKeyChecking=no "${COMMAND}"
	ssh -i ${ID_RSA_PATH}  ubuntu@10.11.4.${i} -o StrictHostKeyChecking=no "sudo rm -rf /home/ubuntu/*-cont*std*-e*.log"
done
