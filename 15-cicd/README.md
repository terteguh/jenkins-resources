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
        stage('Build') {
            steps {
                sh '''
                    ./jenkins/build/mvn.sh mvn -B -DskipTests clean package
                    ./jenkins/build/build.sh

                '''
            }

            post {
                success {
                   archiveArtifacts artifacts: 'java-app/target/*.jar', fingerprint: true
                }
            }
        }
   ```

## TEST


### 142.Test code maven and docker


### 143.Bash script to automate test process


### 144.Add test to jenkins file 


### 145.Test code maven and docker