#!/bin/bash
date
set -x

# To avoid execution without passing environment variables
if [[ (-z "$ID_RSA_PATH") || (-z "$RESULTS_PATH") ||
  (-z "$CONTAINER_TAG") || (-z "$CONTAINER_MEM_LIM") ||
  (-z "$RUNTIME") || (-z "$EXPID") ]];
then
  echo -e "${RED}THERE ARE VARIABLES MISSING: tearDownContainers.sh${NC}"
  exit
fi

LAST_IP_NUMBER="198 218 231 242"
CONTAINERS="container-${RUNTIME}gci container-${RUNTIME}nogci container-${RUNTIME}zero"
COMMAND="sudo docker rm -f ${CONTAINERS}"  # kill all running containers
for i in ${LAST_IP_NUMBER}
do
	ssh-keygen -f "/home/ubuntu/.ssh/known_hosts" -R 10.11.4.${i}
	ssh -i ${ID_RSA_PATH}  ubuntu@10.11.4.${i} -o StrictHostKeyChecking=no "${COMMAND}"
	ssh -i ${ID_RSA_PATH}  ubuntu@10.11.4.${i} -o StrictHostKeyChecking=no "sudo rm -rf /home/ubuntu/*-CONT*-std*-e*.log"
done
sleep 10