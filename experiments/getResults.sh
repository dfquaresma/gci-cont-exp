#!/bin/bash
date
set -x

RED='\033[1;33m'
NC='\033[0m'

# To avoid execution without passing environment variables
if [[ (-z "$ID_RSA_PATH") || (-z "$RESULTS_PATH") ||
  (-z "$CONTAINER_TAG") || (-z "$EXPID") ]];
then
  echo -e "${RED}THERE ARE VARIABLES MISSING: getResults.sh${NC}"
  exit
fi

LAST_IP_NUMBER="198 218 231 242"
for i in ${LAST_IP_NUMBER}
do
	ssh-keygen -f "/home/ubuntu/.ssh/known_hosts" -R 10.11.4.${i}
    COMMAND="sudo docker logs container-${CONTAINER_TAG} >/home/ubuntu/${CONTAINER_TAG}-CONT${i}-stdout-e${EXPID}.log 2>/home/ubuntu/${CONTAINER_TAG}-CONT${i}-stderr-e${EXPID}.log"
  	ssh -i ${ID_RSA_PATH}  ubuntu@10.11.4.${i} -o StrictHostKeyChecking=no "${COMMAND}"
    scp -i ${ID_RSA_PATH} -o StrictHostKeyChecking=no ubuntu@10.11.4.${i}:"/home/ubuntu/*-CONT*-std*-e*.log" $RESULTS_PATH
done

ssh-keygen -f "/home/ubuntu/.ssh/known_hosts" -R 10.11.4.113
scp -i ${ID_RSA_PATH} -o StrictHostKeyChecking=no ubuntu@10.11.4.113:"/var/log/nginx/*.log" $RESULTS_PATH
scp -i ${ID_RSA_PATH} -o StrictHostKeyChecking=no ubuntu@10.11.4.113:"/home/ubuntu/*-YCSB-std*-e*.log" $RESULTS_PATH

mv ${RESULTS_PATH}error.log ${RESULTS_PATH}${CONTAINER_TAG}-NGINX-error-e${EXPID}.log
mv ${RESULTS_PATH}access.log ${RESULTS_PATH}${CONTAINER_TAG}-NGINX-access-e${EXPID}.log
sed -i '1 i\timestamp;status;request_time;upstream_response_time' ${RESULTS_PATH}${CONTAINER_TAG}-NGINX-access-e${EXPID}.log
