pipeline {
    agent {label "slave"}
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
                        docker build -t pratikghose/pet-clinic:${BUILD_NUMBER} .
                        docker ps -qa --filter name=pet-clinic_container|grep -q . && (docker stop pet-clinic_container && docker rm pet-clinic_container) ||echo pet-clinic_container doesn\\'t exists
                        docker run --name pet-clinic_container -d -p 8080:8080 pratikghose/pet-clinic:${BUILD_NUMBER}
                        docker login -u ${username} -p ${password}
                        docker images
                        docker push pratikghose/pet-clinic:${BUILD_NUMBER}
                    '''
                }
            }
        }
        
        
        stage('push to acr') {
            steps {
                dir('Azure Container Registry Upload'){
                    withCredentials([usernamePassword(credentialsId: 'acr-pratik-id',passwordVariable: 'password', usernameVariable: 'username')]) {
                            sh'''
                                export DOCKER_HOME=/usr/local/
                                export PATH=$PATH:$DOCKER_HOME/bin
                                docker login petclinicacr17.azurecr.io -u ${username} -p ${password}
                                docker tag pratikghose/pet-clinic:${BUILD_NUMBER} petclinicacr17.azurecr.io/pet-clinic:${BUILD_NUMBER}
                                docker push petclinicacr17.azurecr.io/pet-clinic:${BUILD_NUMBER}
                            '''
                    }
                }
            }
        }

        stage('Deploy'){
            steps{
                withCredentials([azureServicePrincipal('sp_for_FreeTrial-Nagaraju_sub')]) {
                  sh '''
                    az login --service-principal -u $AZURE_CLIENT_ID -p $AZURE_CLIENT_SECRET -t $AZURE_TENANT_ID
                    az account set -s $AZURE_SUBSCRIPTION_ID
                    #az aks create -n petclinicdemo -g pratik-webapp --generate-ssh-keys --attach-acr /subscriptions/$AZURE_SUBSCRIPTION_ID/resourceGroups/pratik-webapp/providers/Microsoft.ContainerRegistry/registries/petclinicacr17
                    az aks get-credentials --resource-group pratik-webapp --name petclinicdemo
                    kubectl get nodes
                    kubectl set image deployment/petclinic-app webapp=pratikghose/petclinic:${BUILD_NUMBER}
                  '''
                }
                sh 'az logout'
               
            }
        }
            

    }
}
