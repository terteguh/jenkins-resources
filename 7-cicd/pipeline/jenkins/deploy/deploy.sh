#!/bin/bash

echo maven-project > /tmp/.auth
echo $BUILD_TAG >> /tmp/.auth
echo $PASS >> /tmp/.auth

scp -i /opt/prod /tmp/.auth teguh@redhat1.mshome.net:/tmp/.auth
scp -i /opt/prod ./jenkins/deploy/publish teguh@redhat1.mshome.net:/tmp/publish
ssh -i /opt/prod teguh@redhat1.mshome.net "/tmp/publish"
