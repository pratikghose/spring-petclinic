node {
   stage('init') {
      checkout scm
   }
   stage('build') {
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
   stage('deploy') {
      azureWebAppPublish azureCredentialsId: env.AZURE_CRED_ID,
      resourceGroup: env.RES_GROUP, appName: env.WEB_APP, filePath: "**/app.jar"
   }
}
