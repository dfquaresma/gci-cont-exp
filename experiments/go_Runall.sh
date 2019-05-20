#!/bin/bash
date
set -x

RED='\033[0;31m'
NC='\033[0m'

echo "ID_RSA_PATH: ${ID_RSA_PATH:=../../id_rsa}"
echo "RESULTS_PATH: ${RESULTS_PATH:=../analysis/results/}"
echo "EXPID_START: ${EXPID_START:=4}"
echo "EXPID_END: ${EXPID_END:=8}"
echo "GOTAGS: ${GOTAGS:=gogci gonogci gozero}"

for tag in ${GOTAGS};
do
    for expid in `seq ${EXPID_START} ${EXPID_END}`
    do
        echo ""
        echo -e "${RED}EXPID ${tag} ${expid}!${NC}"
        ID_RSA_PATH=${ID_RSA_PATH} RESULTS_PATH=${RESULTS_PATH} CONTAINER_TAG=${tag} EXPID=${expid} bash run.sh
    done
done
