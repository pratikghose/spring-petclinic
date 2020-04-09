pipeline {
    agent any
    stages {
        stage('Build') {
            steps {
                sh label: '', script: '''
                export MAVEN_HOME=/usr/local/Cellar/maven/3.6.3_1/libexec
                export PATH=$PATH:$MAVEN_HOME/bin
                export SONAR_HOME=/usr/local/Cellar/sonar-scanner/4.3.0.2102/libexec
                export PATH=$PATH:$SONAR_HOME/bin
                mvn clean
                mvn compile
                mvn package
                '''
            }
        }
        stage('Code Analysis') {
            steps {
                sh label: '', script: '''
                export MAVEN_HOME=/usr/local/Cellar/maven/3.6.3_1/libexec
                export PATH=$PATH:$MAVEN_HOME/bin
                export SONAR_HOME=/usr/local/Cellar/sonar-scanner/4.3.0.2102/libexec
                export PATH=$PATH:$SONAR_HOME/bin
                mvn verify sonar:sonar
                '''
            }
        }
        
        stage('Containerization') {
            steps {
                sh 'ls'
                withCredentials([usernamePassword(credentialsId: 'Docker-Credentials', passwordVariable: 'password', usernameVariable: 'username')]){
                    sh label: '', script: '''
                    export DOCKER_HOME=/usr/local/
                    export PATH=$PATH:$DOCKER_HOME/bin
                 
                 
                    docker login -u ${username} -p ${password}
                    docker build -t pratikghose/petclinic:1.0.0 .
                    docker push pratikghose/petclinic:1.0.0
                    '''
                }
            }
        }

    }
}
