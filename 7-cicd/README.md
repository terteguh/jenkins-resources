# CICD


## Build 


### 134.Install Docker inside Docker Container
1. Install
   ```sh
   sudo chown 1000:1000 /var/run/docker.sock
   ```

### 135.Define Step Pipeline
1. Install
   ```sh
   
   pipeline {
      agent any

      stages {
         stage('Build') {
               steps {
                  echo 'Building..'
               }
         }
         stage('Test') {
               steps {
                  echo 'Testing..'
               }
         }
         stage('Deploy') {
               steps {
                  echo 'Deploying....'
               }
         }
      }
   }
   
   ```

### 136.Build: Create a Jar
1. Install
   ```sh
   docker run --rm -ti -v $PWD/java-app:/app -v /root/.m2/:/root/.m2/ -w /app maven:3-alpine sh

   docker run --rm -v $PWD/java-app:/app -v /root/.m2/:/root/.m2/ -w /app maven:3-alpine mvn -B -DskipTests clean package
   ```

### 137.Build: Create a Bash
1. Install
   ```sh
   #!/bin/bash

   echo "***************************"
   echo "** Building jar ***********"
   echo "***************************"

   # WORKSPACE=/home/jenkins/jenkins-data/jenkins_home/workspace/pipeline-docker-maven

   docker run --rm  -v  $PWD/java-app:/app -v /root/.m2/:/root/.m2/ -w /app maven:3-alpine "$@"

   ```
2. Running Bash Script
   ```sh
   jenkins/build/mvn.sh mvn -B -DskipTests clean package
   ```


### 138.Build: Create Dockerfile
1. Copy build file
   ```sh
   cp java-app/target/*.jar jenkins/build/
   ```

2. Create docker file 
   ```Dockerfile
   FROM openjdk:8-jre-alpine

   RUN mkdir /app

   COPY *.jar /app/app.jar

   CMD java -jar /app/app.jar

   ```

3. Build Dockerfile
   ```sh
   docker build -f Dockerfile-Java -t test .
   ```

4. Test Dockerfile
   ```sh
   docker run -d test
   6e163215310d4e7a7b6576c328ebcf2d39fe358d619e7b290e0ac03d94bb6616

   docker logs -f 6e163215310d4e7a7b6576c328ebcf2d39fe358d619e7b290e0ac03d94bb6616

   Hello from Pipeline!

   ```


### 139.Build: Create Docker Compose
1. Create docker-compose-build.yml
   ```yml
   version: '3'
   services:
     app:
       image: "maven-project:$BUILD_TAG"
       build:
         context: .
         dockerfile: Dockerfile-Java
   ```

2. manual export build_tag 
   ```sh
   export BUILD_TAG=1
   ```

3. running docker-compose 
   ```sh
   docker-compose -f docker-compose-build.yml build
   ```



### 140.Build: Create bash script - Automate Docker Image Creation
1. Review manual command
   ```sh
   cp java-app/target/*.jar jenkins/build/

   cd jenkins/build/ && docker-compose -f docker-compose-build.yml build --no-cache
   ```

2. Create jenkins/build/build.sh file 
   ```sh
   #!/bin/bash

   # Copy the new jar to the build location
   cp -f java-app/target/*.jar jenkins/build/

   echo "****************************"
   echo "** Building Docker Image ***"
   echo "****************************"

   cd jenkins/build/ && docker-compose -f docker-compose-build.yml build --no-cache
   ```

3. Execute build.sh
   ```sh
   chmod +x jenkins/build/build.sh

   ./jenkins/build/build.sh
   ```

### 141.Build: Add script to Jenkinsfile
1. edit Jenkinsfile
   ```sh
   ./jenkins/build/mvn.sh mvn -B -DskipTests clean package
   ./jenkins/build/build.sh
   ```

## TEST

### 142.Test code maven and docker
1. Manual code maven test
   ```sh
   docker run --rm -v $PWD/java-app:/app -v /root/.m2/:/root/.m2/ -w /app maven:3-alpine mvn test
   ```

### 143.Bash script to automate test process
1. Create jenkins/test directory
   ```sh
   mkdir jenkins/test
   ```

### 144.Add test to jenkins file 
1. Create jenkins/test directory
   ```sh
   sh './jenkins/test/mvn.sh mvn test'
   ```


### 145.Create remote VM to deploy container app

## PUSH

### 146. Create docker hub
1. Create new account on dockerhub

### 147. Create Repository in Docker Hub
1. Create new repository on dockerhub

### 148. Push/Pull docker images to your Repository
1. login
   ```sh
   docker login
   docker tag app:2 tevoeh/jenkinscicd:2
   docker push tevoeh/jenkinscicd:$BUILD_TAG
   ```

### 149. Create Bash Script to Automate Push Process 
1. Create jenkins/test directory
   ```sh
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
   ```

### 150. add Push Script to Jenkinsfile 
1. Jenkinsfile
   ```sh
   sh './jenkins/push/push.sh'
   ```

## DEPLOY

### 151. Transfer Variables to Remote Machine 
1. Create jenkins/deploy directory
   ```sh
   mkdir jenkins/deploy
   ```

2. Create deploy.sh
   ```sh
   #!/bin/bash

   echo maven-project > /tmp/.auth
   echo $BUILD_TAG >> /tmp/.auth
   echo $PASS >> /tmp/.auth

   scp -i /opt/prod /tmp/.auth prod-user@linuxfacilito.online:/tmp/.auth
   scp -i /opt/prod ./jenkins/deploy/publish prod-user@linuxfacilito.online:/tmp/publish
   ssh -i /opt/prod prod-user@linuxfacilito.online "/tmp/publish"

   ```
### 152. Deploy Application on Remote Machine Manually
1. Create publish on remote machine
   ```sh
   #!/bin/bash

   export IMAGE=$(sed -n '1p' /tmp/.auth)
   export TAG=$(sed -n '2p' /tmp/.auth)
   export PASS=$(sed -n '3p' /tmp/.auth)

   docker login -u ricardoandre97 -p $PASS
   cd ~/maven && docker-compose up -d
   ```

### 153. Create Deployment Script to Remote Machine
1. Create docker-compose on remote machine
   ```sh
   version: '3'
   services:
   maven:
      image: "tevoeh/$IMAGE:TAG"
      container_name: maven-app
   ```

### 154. Execute Deployment Script to Remote Machine
1. check publish file
   ```sh
   ssh -i /opt/prod prod-user@linuxfacilito.online "/tmp/publish"
   ```

### 155. Add Deploy Script in Remote Machine
1. Create jenkins/test directory
   ```sh
   sh './jenkins/deploy/deploy.sh'
   ```

### 156. Store Script in Git Repository
1. Create jenkins/test directory
   ```sh
   sh './jenkins/test/mvn.sh mvn test'
   ```

### 157. Create Jenkins Pipeline
1. Create jenkins/test directory
   ```sh
   sh './jenkins/test/mvn.sh mvn test'
   ```

### 158. Modify path when mounting Docker volumes
1. Create jenkins/test directory
   ```sh
   sh './jenkins/test/mvn.sh mvn test'
   ```

### 159. Create Password Registry
1. Create jenkins/test directory
   ```sh
   sh './jenkins/test/mvn.sh mvn test'
   ```
