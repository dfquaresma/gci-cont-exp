#!/bin/bash
date
set -x

# To avoid execution without passing environment variables
if [[ (-z "$ID_RSA_PATH") ]];
then
  echo -e "${RED}THERE ARE VARIABLES MISSING: updateContainers.sh${NC}"
  exit
fi

LAST_IP_NUMBER="198 218 231 242"
COMMAND="bash /home/ubuntu/socc19/setup/update-container.sh"
for i in ${LAST_IP_NUMBER}
do
	ssh-keygen -f "/home/ubuntu/.ssh/known_hosts" -R 10.11.4.${i}
	ssh -i ${ID_RSA_PATH}  ubuntu@10.11.4.${i} -o StrictHostKeyChecking=no "${COMMAND}"
done
