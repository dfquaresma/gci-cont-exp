#!/bin/bash
date
set -x

BLUE='\033[0;34m'
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo "ID_RSA_PATH: ${ID_RSA_PATH}"
echo "RESULTS_PATH: ${RESULTS_PATH}"
echo "CONTAINER_TAG: ${CONTAINER_TAG}"
echo "RUNTIME: ${RUNTIME}"
echo "EXPID: ${EXPID}"

# To avoid execution without passing environment variables
[ ! -z "$ID_RSA_PATH" ] && [ ! -z "$RESULTS_PATH" ] && [ ! -z "$CONTAINER_TAG" ] && [ ! -z "$RUNTIME" ] && [ ! -z "$EXPID" ] || exit

echo -e "${YELLOW}TEARING DOWN CONTAINERS${NC}"
ID_RSA_PATH=${ID_RSA_PATH} RUNTIME=${RUNTIME} bash tearDownContainers.sh

echo -e "${BLUE}SETTING UP CONTAINERS${NC}"
ID_RSA_PATH=${ID_RSA_PATH} CONTAINER_TAG=${CONTAINER_TAG} bash setUpContainers.sh

echo -e "${RED}RUNNING WORKLOAD FOR ${CONTAINER_TAG} EXPID ${EXPID}${NC}"
ID_RSA_PATH=${ID_RSA_PATH} EXPID=${EXPID} bash workload.sh

echo -e "${RED}GETTING RESULTS${NC}"
mkdir -p $RESULTS_PATH
ID_RSA_PATH=${ID_RSA_PATH} RESULTS_PATH=$RESULTS_PATH CONTAINER_TAG=${CONTAINER_TAG} EXPID=${EXPID} bash getResults.sh

echo -e "${YELLOW}TEARING DOWN CONTAINERS${NC}"
ID_RSA_PATH=${ID_RSA_PATH} RUNTIME=${RUNTIME} bash tearDownContainers.sh

echo -e "${GREEN}EXPERIMENT FINISHED${NC}"
