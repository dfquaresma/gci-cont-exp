#!/bin/bash
date
set -x

echo "ID_RSA_PATH: ${ID_RSA_PATH}"
echo "RESULTS_PATH: ${RESULTS_PATH}"
echo "CONTAINER_TAG: ${CONTAINER_TAG}"
echo "EXPERIMENT: ${EXPERIMENT}"
echo "ROUND: ${ROUND}"

# To avoid execution without passing environment variables
[ ! -z "$ID_RSA_PATH" ] && [ ! -z "$RESULTS_PATH" ] && [ ! -z "$CONTAINER_TAG" ] && [ ! -z "$EXPERIMENT" ] && [ ! -z "$ROUND" ] || exit

ID_RSA_PATH=${ID_RSA_PATH} CONTAINER_TAG=${CONTAINER_TAG} bash tearDownContainers.sh
ID_RSA_PATH=${ID_RSA_PATH} CONTAINER_TAG=${CONTAINER_TAG} bash setUpContainers.sh

ID_RSA_PATH=${ID_RSA_PATH} bash workload.sh
ID_RSA_PATH=${ID_RSA_PATH} CONTAINER_TAG=${CONTAINER_TAG} bash tearDownContainers.sh

mkdir -p $RESULTS_PATH
ID_RSA_PATH=${ID_RSA_PATH} RESULTS_PATH=$RESULTS_PATH CONTAINER_TAG=${CONTAINER_TAG} EXPERIMENT=${EXPERIMENT} ROUND=${ROUND} bash getResults.sh
