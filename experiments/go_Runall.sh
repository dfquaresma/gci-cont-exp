#!/bin/bash
date
set -x

RED='\033[0;31m'
NC='\033[0m'

echo "ID_RSA_PATH: ${ID_RSA_PATH:=../../id_rsa}"
echo "RESULTS_PATH: ${RESULTS_PATH:=../analysis/results/}"
echo "EXPID_START: ${EXPID_START:=0}"
#echo "EXPID_END: ${EXPID_END:=2}"
echo "GOTAGS: ${GOTAGS:=gonogci gogci gozero}"
echo "RUNTIME: ${RUNTIME:=go}"
echo "CONTAINER_MEM_LIM: ${CONTAINER_MEM_LIM:=3g}"

for expid in `seq ${EXPID_START} ${EXPID_END}`
do
    for tag in ${GOTAGS};
    do
        echo ""
        echo -e "${RED}Running ${tag} EXPID ${expid}!${NC}"
        ID_RSA_PATH=${ID_RSA_PATH} RESULTS_PATH=${RESULTS_PATH} CONTAINER_TAG=${tag} CONTAINER_MEM_LIM=${CONTAINER_MEM_LIM} RUNTIME=${RUNTIME} EXPID=${expid} bash run.sh
    done
done
