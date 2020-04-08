FROM openjdk:8-alpine
WORKDIR /Users/pratik/.jenkins/workspace/Maven-pipeline-test/target
CMD java -jar spring-petclinic-2.2.0.BUILD-SNAPSHOT.jar
