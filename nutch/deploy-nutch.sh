#!/bin/bash

# Usage:
# build.sh registryhostname targethostname

REGISTRY_HOST=$1
TARGET_HOST=$2
VOLUME_PATH=${3:-/docker-data/devnetwork-nutch-temp}

CONTAINER_NAME=${CONTAINER_NAME:-nutchcontainer}
IMAGE=${IMAGE:-"nhsd-nutch"}
CORE_NAME=${CORE_NAME:-developernetwork}

if [ -z $TARGET_HOST ]
then
  TARGET_PREFIX=""
else
  TARGET_PREFIX="--tlsverify -H $TARGET_HOST:2376"
fi

if [ -z $REGISTRY_HOST ]
then
  # No private docker registry
  REGISTRY_PREFIX=""
  SOURCE_URL=$IMAGE
else
  # Registry specified, so use it
  REGISTRY_PREFIX="--tlsverify -H $REGISTRY_HOST:2376"
  SOURCE_URL=$REGISTRY_HOST:5000/$IMAGE
  docker $TARGET_PREFIX pull $SOURCE_URL
fi

MEMORYFLAG=750m
CPUFLAG=768

echo "Pull and run Nutch"
docker $TARGET_PREFIX stop $CONTAINER_NAME
docker $TARGET_PREFIX rm $CONTAINER_NAME
docker $TARGET_PREFIX run --name $CONTAINER_NAME \
	-v $VOLUME_PATH:/root/nutch/crawl \
	--link solr-developernetwork:solr-developernetwork \
	$SOURCE_URL \
#	--net=host \
# 	--userns=host \
#	-v $VOLUME_PATH:/root/nutch/crawl \
#	-d \
#	$SOURCE_URL \
#	/bin/bash


