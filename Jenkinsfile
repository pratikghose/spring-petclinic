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
                mvn clean -Dcheckstyle.skip
                mvn compile -Dcheckstyle.skip
                mvn package -Dcheckstyle.skip
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
                mvn verify sonar:sonar -Dcheckstyle.skip
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
        
        
        stage('Deploy') {
            steps {
                dir('TerraformModules'){
                    withCredentials([string(credentialsId: 'subscription-id', variable: 'subid'), string(credentialsId: 'tenant-id', variable: 'tenantid'), string(credentialsId: 'client-id', variable: 'clientid'), string(credentialsId: 'client-secret', variable: 'clientsecret')]) {
                        sh label: '', script: '''
                            export TERRAFORM_HOME=/usr/local
                            export PATH=$PATH:$TERRAFORM_HOME/bin
                            terraform init -input=falseterraform destroy -var="subscription_id=${subid}" -var="client_id=${clientid}" -var="client_secret=${clientsecret}" -var="tenant_id=${tenantid}" -input=false -auto-approve
                            terraform destroy -var="subscription_id=${subscription_id}" -var="client_id=${client_id}" -var="client_secret=${client_secret}" -var="tenant_id=${tenant_id}" -input=false -auto-approve
                            terraform apply -var="prefix=prod${BUILD_NUMBER}" -var="subscription_id=${subid}" -var="client_id=${clientid}" -var="client_secret=${clientsecret}" -var="tenant_id=${tenantid}" -input=false -auto-approve
                            terraform output
                        '''
                    }
                }
            }
        }
        
        stage('Email Notification') {
        steps {
			emailext (
                to: "prateekghose765@gmail.com",
                subject: '${DEFAULT_SUBJECT}',
                body: '${DEFAULT_CONTENT}',
            )
        }
    }
            

    }
}
