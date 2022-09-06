pipeline{
    agent any
    tools{
        maven 'maven-3.8.6'
    }
    environment{
        registry='682853443183.dkr.ecr.us-east-1.amazonaws.com/java'
    }
    stages{
        stage('Clone Git-Repo'){
            steps{
                git branch: 'master', url: 'https://github.com/pandrajucs/hello-world.git'
            }
        }
        stage('Build-Maven'){
            steps{
                sh 'mvn clean package'
            }
        }
        stage('Build Docker-Image'){
            steps{
                script{
                    dockerImage = docker.build registry + ":$BUILD_NUMBER"
                }

            }
        }
        stage('Push Docker-Image to ECR'){
            steps{
                script{
                     sh 'aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 682853443183.dkr.ecr.us-east-1.amazonaws.com'
                       dockerImage.push()
                       }
                }
        }
        stage('Pull Docker-Image to K8S-Sever and Run Deployment'){
            steps{
                ansiblePlaybook become: true, credentialsId: 'ansible', inventory: 'inventory', playbook: 'k8s.yml'
            }
        }


    }
    post {
        success {
                    slackSend botUser: true, channel: '#java-projects', message: "started Job: ${env.JOB_NAME} Build Number: ${env.BUILD_NUMBER} BUILD URL :(<${env.BUILD_URL}|Open>) Build status is : ${currentBuild.currentResult}", teamDomain: 'JavaProjects', tokenCredentialId: 'slack'
            }
        failure {
                slackSend botUser: true, channel: '#java-projects', message: "started Job: ${env.JOB_NAME} Build Number: ${env.BUILD_NUMBER} BUILD URL :(<${env.BUILD_URL}|Open>) Build status is : ${currentBuild.currentResult}", teamDomain: 'JavaProjects', tokenCredentialId: 'slack'
            }
        }

}
