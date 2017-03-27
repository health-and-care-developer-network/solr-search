#!/bin/bash

# Usage:
# build.sh volumepath registryhostname targethostname

VOLUME_PATH=${1:-/docker-data/devnetwork-solr-index}
REGISTRY_HOST=$2
TARGET_HOST=$3

# Parameters can be set via environment variables (or locally scoped variables in the
# call to this script - e.g. `DB=blah deploy-openods.sh`), which will be passed through
# into the container
#DB=${DB:-openods}
#DB_USER=${DB_USER:-openods}
#DB_PASSWORD=${DB_PASSWORD:-openods}
CONTAINER_NAME=${CONTAINER_NAME:-solr-developernetwork}
IMAGE=${IMAGE:-"nhsd-solr"}
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

  echo "Ensure the image is in our registry, and if not add it"
  ./populateImageIntoRegistry.sh $IMAGE $REGISTRY_HOST
fi

MEMORYFLAG=750m
CPUFLAG=768

echo "Pull and run Solr"
docker $TARGET_PREFIX stop $CONTAINER_NAME
docker $TARGET_PREFIX rm $CONTAINER_NAME

docker $TARGET_PREFIX run --name $CONTAINER_NAME \
	--restart=on-failure:5 \
        -m $MEMORYFLAG \
	-c $CPUFLAG \
	-p 8983:8983 \
	-v $VOLUME_PATH:/opt/solr/server/solr/mycores \
	-d $SOURCE_URL \
	solr-precreate developernetwork /opt/solr/server/solr/wordpress-plugin-config


#docker $TARGET_PREFIX run --name $CONTAINER_NAME \
#	--restart=on-failure:5 \
#        -m $MEMORYFLAG \
#	-c $CPUFLAG \
#	-p 8983:8983 \
#	-v $VOLUME_PATH:/opt/solr/server/solr/mycores \
#	-d $SOURCE_URL

# Now, create our Solr "core"
#sleep 5
#docker exec -it --user=solr $CONTAINER_NAME bin/solr create_core -c $CORE_NAME -d /opt/solr/server/solr/wordpress-plugin-config

