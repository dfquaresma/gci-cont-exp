#!/bin/bash
date
set -x

echo "RESULTS_PATH: ${RESULTS_PATH}"
echo "CONTAINER_TAG: ${CONTAINER_TAG}"
echo "EXPERIMENT: ${EXPERIMENT}"
echo "ROUND: ${ROUND}"

# To avoid execution without passing environment variables
[ ! -z "$RESULTS_PATH" ] && [ ! -z "$CONTAINER_TAG" ] && [ ! -z "$EXPERIMENT" ] && [ ! -z "$ROUND" ] || exit

CONTAINER_TAG=${CONTAINER_TAG} bash tearDownContainers.sh
CONTAINER_TAG=${CONTAINER_TAG} bash setUpContainers.sh
bash workload.sh
CONTAINER_TAG=${CONTAINER_TAG} bash tearDownContainers.sh

mkdir -p $RESULTS_PATH
RESULTS_PATH=$RESULTS_PATH CONTAINER_TAG=${CONTAINER_TAG} EXPERIMENT=${EXPERIMENT} ROUND=${ROUND} bash getResults.sh
