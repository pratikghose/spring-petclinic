pipeline {
    agent any
    stages {
       stage('init') {
          step{
             checkout scm
          }
      }
        stage('Build') {
            steps {
                sh '''
                  export MAVEN_HOME=/usr/local/Cellar/maven/3.6.3_1/libexec
                  export PATH=$PATH:$MAVEN_HOME/bin
                  mvn clean package
                  cd target
                  cp ../src/main/resources/web.config web.config
                  cp spring-petclinic-2.2.0.BUILD-SNAPSHOT.jar app.jar 
                  zip todo.zip app.jar web.config
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
                    docker build -t pratikghose/petclinic:1.0.${BUILD_NUMBER} .
                    docker push pratikghose/petclinic:1.0.${BUILD_NUMBER}
                    '''
                }
            }
        }
        
        
        stage('Deploy') {
            steps {
               
               def resourceGroup = 'pratik-webapp'
    def webAppName = 'petclinic1'
    def registryServer = 'https://hub.docker.com/repository/docker/pratikghose/'
    def imageTag = 'latest'
    def imageName = "$registryServer/petclinic"
    azureWebAppPublish azureCredentialsId: env.AZURE_CRED_ID, publishType: 'docker', resourceGroup: resourceGroup, 
       appName: webAppName, dockerImageName: imageName, 
       dockerImageTag: imageTag
            }
        }
 

    }
}

