#!/bin/bash
date
set -x

LAST_IP_NUMBER="198 218 231 242"
COMMAND="sudo docker run --network=host --rm --name container-${CONTAINER_TAG} image-${CONTAINER_TAG} &"
for i in ${LAST_IP_NUMBER}
do
	ssh-keygen -f "/home/ubuntu/.ssh/known_hosts" -R 10.11.4.${i}
	ssh -i ${ID_RSA_PATH}  ubuntu@10.11.4.${i} -o StrictHostKeyChecking=no "${COMMAND}"
done
sleep 10
