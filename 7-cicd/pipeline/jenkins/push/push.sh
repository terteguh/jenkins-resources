#!/bin/bash

echo "********************"
echo "** Pushing image ***"
echo "********************"

IMAGE="jenkinscicd"

echo "** Logging in ***"
docker login -u tevoeh -p $PASS
echo "*** Tagging image ***"
docker tag $IMAGE:$BUILD_TAG tevoeh/$IMAGE:$BUILD_TAG
echo "*** Pushing image ***"
docker push tevoeh/$IMAGE:$BUILD_TAG
