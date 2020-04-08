FROM openjdk:8-alpine
COPY /Users/pratik/.jenkins/workspace/Maven-pipeline-test/target /usr/myapp
WORKDIR /usr/myapp
CMD java -jar spring-petclinic-2.2.0.BUILD-SNAPSHOT.jar
