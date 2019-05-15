#!/bin/bash
date
set -x

CONTAINER_TAG=${CONTAINER_TAG} bash tearDownContainers.sh
CONTAINER_TAG=${CONTAINER_TAG} bash setUpContainers.sh
bash workload.sh
CONTAINER_TAG=${CONTAINER_TAG} bash tearDownContainers.sh

mkdir -p $RESULTS_PATH
RESULTS_PATH=$RESULTS_PATH CONTAINER_TAG=${CONTAINER_TAG} EXPERIMENT=${EXPERIMENT} ROUND=${ROUND} bash getResults.sh
