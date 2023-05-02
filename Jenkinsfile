pipeline {
   tools {
        maven 'Maven3'      
    }
    agent any
    environment {
        registry = "account_id.dkr.ecr.us-east-2.amazonaws.com/my-docker-repo"
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
    stage('Building image') {
      steps{
        script {
          sh 'aws ecr get-login-password --region us-west-2 | docker login --username AWS --password-stdin accountid.dkr.ecr.us-west-2.amazonaws.com'
          sh 'docker build -t accountid.dkr.ecr.us-west-2.amazonaws.com/my-repo .'
          

        }
      }
    }
   
   
    // Uploading Docker images into AWS ECR
    stage('Pushing to ECR') {
     steps{  
         script {
                sh 'aws ecr get-login-password --region us-west-2 | docker login --username AWS --password-stdin account_id.dkr.ecr.us-west-2.amazonaws.com'
                sh 'docker push account_id.dkr.ecr.us-west-2.amazonaws.com/my-docker-repo:latest'
         }
        }
      }

       stage('K8S Deploy') {
        steps{   
            script {
                withKubeConfig([credentialsId: 'K8S', serverUrl: '']) {
                sh ('kubectl apply -f  eks-deploy-k8s.yaml')
                }
            }
        }
       }
    }
}
