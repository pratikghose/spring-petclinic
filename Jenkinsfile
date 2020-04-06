pipeline {
    agent any
    stages {
        stage('Build'){
            steps {
                sh label: '', script: '''
                export MAVEN_HOME=/usr/local/Cellar/maven/3.6.3_1/libexec
                export PATH=$PATH:$MAVEN_HOME/bin
                mvn clean
                mvn compile
                mvn verify
                '''
            }
        }
    }
}
