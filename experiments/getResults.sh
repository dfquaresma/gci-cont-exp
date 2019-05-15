#!/bin/bash
date
set -x

ssh-keygen -f "/home/ubuntu/.ssh/known_hosts" -R 10.11.4.113
scp -i ${ID_RSA_PATH} -o StrictHostKeyChecking=no ubuntu@10.11.4.113:"/var/log/nginx/*.log" $RESULTS_PATH
mv ${RESULTS_PATH}access.log ${RESULTS_PATH}${CONTAINER_TAG}-access-e${EXPERIMENT}r${ROUND}.log
sed -i '1 i\timestamp;status;request_time;upstream_response_time' ${RESULTS_PATH}${CONTAINER_TAG}-access-e${EXPERIMENT}r${ROUND}.log
mv ${RESULTS_PATH}error.log ${RESULTS_PATH}${CONTAINER_TAG}-error-e${EXPERIMENT}r${ROUND}.log