pipeline {
    agent any
    stages {
        stage('Build') {
            steps {
                sh "pwd"
                sh "ls -lrtha"
                sh "./mvnw clean package -Dcheckstyle.skip"
            }
        }   
        stage('Containerization') {
            steps {
                sh 'ls'
                withCredentials([usernamePassword(credentialsId: 'docker-creds-pratik', passwordVariable: 'password', usernameVariable: 'username')]){
                    sh '''
                        export DOCKER_HOME=/usr/local/
                        export PATH=$PATH:$DOCKER_HOME/bin
                        docker build -t pratikghose/pet-clinic:v1 .
                        docker ps -q --filter name=pet-clinic_container|grep -q . && (docker stop pet-clinic_container && docker rm pet-clinic_container) ||echo pet-clinic_container doesn\\'t exists
                        docker run --name pet-clinic_container -d -p 8080:8080 pratikghose/pet-clinic:v1
                        docker login -u ${username} -p ${password}
                        docker images
                        docker push pratikghose/pet-clinic:v1
                    '''
                }
            }
        }
        
        
        stage('Deploy') {
            steps {
                dir('Azure Container Registry Upload'){
                    withCredentials([usernamePassword(credentialsId: 'acr-pratik-id',passwordVariable: 'password', usernameVariable: 'username')]) {
                            sh'''
                                export DOCKER_HOME=/usr/local/
                                export PATH=$PATH:$DOCKER_HOME/bin
                                docker login petclinicacr17.azurecr.io -u ${username} -p ${password}
                                docker tag pratikghose/pet-clinic:v1 petclinicacr17.azurecr.io/pet-clinic:v1
                                docker push petclinicacr17.azurecr.io/pet-clinic:v1
                            '''
                    }
                }
            }
        }
            

    }
}
