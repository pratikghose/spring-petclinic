FROM openjdk:8-alpine
WORKDIR /Users/pratik/.jenkins/workspace/Maven-pipeline-test/target
CMD java -jar *.jar
