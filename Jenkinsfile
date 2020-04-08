pipeline {
    agent any
    stages {
        stage('Build and Code Analysis') {
            steps {
                sh label: '', script: '''
                export MAVEN_HOME=/usr/local/Cellar/maven/3.6.3_1/libexec
                export PATH=$PATH:$MAVEN_HOME/bin
                export SONAR_HOME=/usr/local/Cellar/sonar-scanner/4.3.0.2102/libexec
                export PATH=$PATH:$SONAR_HOME/bin
                mvn clean
                mvn compile
                mvn verify
                mvn package
                mvn verify sonar:sonar
                '''
            }
        }

    }
}
