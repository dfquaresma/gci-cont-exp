#!/bin/bash
date
set -x

RED='\033[0;31m'
NC='\033[0m'

echo "ID_RSA_PATH: ${ID_RSA_PATH:=../../id_rsa}"
echo "RESULTS_PATH: ${RESULTS_PATH:=../analysis/results/}"
echo "EXPID_START: ${EXPID_START:=10}"
echo "EXPID_END: ${EXPID_END:=14}"
echo "GOTAGS: ${GOTAGS:=gogci gonogci gozero}"
echo "RUNTIME: ${RUNTIME:=go}"

for expid in `seq ${EXPID_START} ${EXPID_END}`
do
    for tag in ${GOTAGS};
    do
        echo ""
        echo -e "${RED}Running ${tag} EXPID ${expid}!${NC}"
        ID_RSA_PATH=${ID_RSA_PATH} RESULTS_PATH=${RESULTS_PATH} CONTAINER_TAG=${tag} RUNTIME=${RUNTIME} EXPID=${expid} bash run.sh
    done
done
