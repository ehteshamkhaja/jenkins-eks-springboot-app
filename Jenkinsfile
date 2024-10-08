pipeline {
   tools {
        maven 'Maven3'      
    }
    agent any
  
   
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
                    docker build --platform linux/aarch64 -t khajaehtesham/todoapp:${BUILD_NUMBER} .
                    '''
                }
            }
        }
   
   
    // Uploading Docker images into AWS ECR
   stage('Push the artifacts'){
           steps{
                script{
                    sh '''
                    docker login -u ehteshamkhaja@gmail.com -p Ehtesdfvam@11234567890
                    echo 'Push to Repo'
                    docker push khajaehtesham/todoapp:${BUILD_NUMBER}
                    '''
                }
            }
        }
    stage('Checkout K8S manifest SCM'){
            steps { 
               git credentialsId: 'git-login', url: 'https://github.com/ehteshamkhaja/cicd-manifests-k8s.git',
                branch: 'master'
            }
        }

        stage('Update K8S manifest & push to Repo'){
            steps {
                
                script{
             withCredentials([gitUsernamePassword(credentialsId: 'git-login', gitToolName: 'Default')]) {
                  sh "echo 'testing job'"
                   sh "git config user.email ehteshamkhaja@gmail.com"
                  sh "git config user.name KhajaEhtesham"
                  sh "cat manifests/deployment.yaml"
                    sh "cd manifests && sed -i 's+khajaehtesham/todoapp.*+khajaehtesham/todoapp:${BUILD_NUMBER}+g' deployment.yaml"
                   sh  "git add -A"
                   sh "git commit -m 'Done by Jenkins Job changemanifest: ${env.BUILD_NUMBER}'"
                   sh "git push https://github.com/ehteshamkhaja/cicd-manifests-k8s.git HEAD:master"
 
                    }
                } 
            }
        }

    } 

}
