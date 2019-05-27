#!/bin/bash
date
set -x

# To avoid execution without passing environment variables
if [[ (-z "$ID_RSA_PATH") || (-z "$CONTAINER_TAG") || (-z "$CONTAINER_MEM_LIM") ]];
then
  echo -e "${RED}THERE ARE VARIABLES MISSING: setUpContainers.sh${NC}"
  exit
fi

LAST_IP_NUMBER="198 218 231 242"
COMMAND="sudo docker run -d --network=host --cpus=1.0 --memory=${CONTAINER_MEM_LIM} --memory-swap=${CONTAINER_MEM_LIM} --rm --name container-${CONTAINER_TAG} image-${CONTAINER_TAG}"
for i in ${LAST_IP_NUMBER}
do
	ssh-keygen -f "/home/ubuntu/.ssh/known_hosts" -R 10.11.4.${i}
	ssh -i ${ID_RSA_PATH}  ubuntu@10.11.4.${i} -o StrictHostKeyChecking=no "${COMMAND}"
done
sleep 10
