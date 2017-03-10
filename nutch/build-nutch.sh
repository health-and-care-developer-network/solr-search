#!/bin/bash

# Usage:
# build.sh registryhostname

REGISTRY_HOST=$1
IMAGE_NAME=nhsd-nutch
REGISTRY_URL=$REGISTRY_HOST:5000

if [ -z $REGISTRY_HOST ]
then
  REGISTRY_PREFIX=""
else
  REGISTRY_PREFIX="--tlsverify -H $REGISTRY_HOST:2376"
fi

# Build the solr image
set -e # Stop on error
docker $REGISTRY_PREFIX build -t $IMAGE_NAME .

# Push to registry
if [ ! -z $REGISTRY_HOST ]
then
  docker $REGISTRY_PREFIX tag $IMAGE_NAME $REGISTRY_URL/$IMAGE_NAME
  docker $REGISTRY_PREFIX push $REGISTRY_URL/$IMAGE_NAME
  docker $REGISTRY_PREFIX rmi $IMAGE_NAME
fi

