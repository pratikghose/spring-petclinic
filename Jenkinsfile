pipeline {
    agent any
    stages {
        stage('Build and Code Analysis') {
            steps {
                sh label: '', script: '''
                export MAVEN_HOME=/usr/local/Cellar/maven/3.6.3_1/libexec
                export PATH=$PATH:$MAVEN_HOME/bin
                //mvn clean
                //mvn compile
                //mvn verify
                //mvn package
                vn verify sonar:sonar
                '''
            }
        }

    }
}
