#!/bin/bash
date
set -x

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo "ID_RSA_PATH: ${ID_RSA_PATH}"
echo "RESULTS_PATH: ${RESULTS_PATH}"
echo "CONTAINER_TAG: ${CONTAINER_TAG}"
echo "CONTAINER_MEM_LIM: ${CONTAINER_MEM_LIM}"
echo "RUNTIME: ${RUNTIME}"
echo "EXPID: ${EXPID}"

# To avoid execution without passing environment variables
if [[ (-z "$ID_RSA_PATH") || (-z "$RESULTS_PATH") ||
  (-z "$CONTAINER_TAG") || (-z "$CONTAINER_MEM_LIM") ||
  (-z "$RUNTIME") || (-z "$EXPID") ]];
then
  echo -e "${RED}THERE ARE VARIABLES MISSING: run.sh${NC}"
  exit
fi

echo -e "${YELLOW}TEARING DOWN CONTAINERS${NC}"
bash tearDownContainers.sh
echo -e "${YELLOW}SETTING UP CONTAINERS${NC}"
bash setUpContainers.sh

echo -e "${RED}RUNNING WORKLOAD FOR ${CONTAINER_TAG} EXPID ${EXPID}${NC}"
bash workload.sh

echo -e "${RED}GETTING RESULTS${NC}"
mkdir -p $RESULTS_PATH
bash getResults.sh
echo -e "${YELLOW}TEARING DOWN CONTAINERS${NC}"
bash tearDownContainers.sh

echo -e "${GREEN}EXPERIMENT FINISHED${NC}"
