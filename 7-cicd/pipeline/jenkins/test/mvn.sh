#!/bin/bash

echo "***************************"
echo "** Test jar ***********"
echo "***************************"

# WORKSPACE=/home/jenkins/jenkins-data/jenkins_home/workspace/pipeline-docker-maven

docker run --rm  -v  $PWD/java-app:/app -v /root/.m2/:/root/.m2/ -w /app maven:3-alpine "$@"


# teguh@TeguhF:~/jenkins-resources/15-cicd/pipeline$ pwd
# /home/teguh/jenkins-resources/15-cicd/pipeline
# teguh@TeguhF:~/jenkins-resources/15-cicd/pipeline$ ls
# Dockerfile  java-app  jenkins
# teguh@TeguhF:~/jenkins-resources/15-cicd/pipeline$ jenkins/build/mvn.sh test
