pipeline {
    agent any
    stages {
        stage ('Initialize') {
            steps {
                sh '''
                    export MAVEN_HOME=/usr/local/Cellar/maven/3.6.3_1/libexec
                    export PATH=$PATH:$MAVEN_HOME/bin
                ''' 
            }
        }
        stage('Build'){
            steps {
                sh label: '', script: '''
                mvn clean
                mvn compile
                mvn verify
                '''
            }
        }
    }
}
