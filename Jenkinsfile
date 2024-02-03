pipeline {
   tools {
        maven 'Maven3'      
    }
    agent any
    environment {
       // registry = "account_id.dkr.ecr.us-east-2.amazonaws.com/my-docker-repo"
    }
   
    stages {
        stage('Cloning Git') {
            steps {
                checkout([$class: 'GitSCM', branches: [[name: '*/master']], doGenerateSubmoduleConfigurations: false, extensions: [], submoduleCfg: [], userRemoteConfigs: [[credentialsId: '', url: 'https://github.com/ehteshamkhaja/jenkins-eks-springboot-app.git']]])     
            }
        }
      stage ('Build') {
          steps {
            sh 'mvn clean install'           
            }
      }
    // Building Docker images

    stage('Build Docker'){
            steps{
                script{
                    sh '''
                    echo 'Buid Docker Image'
                    docker build -t khajaehtesham/todoapp:${BUILD_NUMBER} .
                    '''
                }
            }
        }
   
   
    // Uploading Docker images into AWS ECR
   stage('Push the artifacts'){
           steps{
                script{
                    sh '''
                    docker login -u ehteshamkhaja@gmail.com -p Ehtesham@1251
                    echo 'Push to Repo'
                    docker push khajaehtesham/todoapp:${BUILD_NUMBER}
                    '''
                }
            }
        }
    /*    
       stage('K8S Deploy') {
        steps{   
            script {
                withKubeConfig([credentialsId: 'K8S', serverUrl: '']) {
                sh ('kubectl apply -f  eks-deploy-k8s.yaml')
                }
            }
        }
       }
       */

    } 
|
}
