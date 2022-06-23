pipeline{
    agent any
    // Declare environment variables
    environment {
        PATH = "$PATH:/home/jenkins/apache-maven-3.6.3"
	    AWS_ACCOUNT_ID="646382203106"
        AWS_DEFAULT_REGION="ap-south-1" 
        IMAGE_REPO_NAME="demo-registry"
        IMAGE_TAG="emp_mgmt_"
        REPOSITORY_URI = "${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_DEFAULT_REGION}.amazonaws.com/${IMAGE_REPO_NAME}"
    }
    stages{
       // Pulling code from remote rpository 
       stage('Get Code'){
            steps{
                git branch: 'develop', credentialsId: 'jenkins-gitlab', url: 'http://ec2-13-234-21-152.ap-south-1.compute.amazonaws.com/globant-demo/employee-mgmt-system'
            }
         }
		// Build application using maven 
        stage('Maven Build'){
            steps{
                sh 'mvn clean package'
            }
         }
        // Scan code using SonarQube
		stage('Scan Code') {
        steps{
        withSonarQubeEnv('SonarServer') { 
        sh "mvn sonar:sonar"
        }
      }
    }
		stage('Docker Build') {
		steps{
			script {
                sh "git rev-parse --short HEAD > commit"
                def COMMIT_ID = readFile('commit').trim()
                
                // Build docker image using Dockerfile
				dockerImage = docker.build "${IMAGE_REPO_NAME}:${IMAGE_TAG}"

                // Docker tag and push image into aws ecr
                sh "docker tag ${IMAGE_REPO_NAME}:${IMAGE_TAG} ${REPOSITORY_URI}:${IMAGE_TAG}${COMMIT_ID}"
				sh "docker push ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_DEFAULT_REGION}.amazonaws.com/${IMAGE_REPO_NAME}:${IMAGE_TAG}${COMMIT_ID}"
				}
			}
		}
        // Deployment of application using aws eks.
        stage('Deployment') {
        steps{
          script{
                    def COMMIT_ID = readFile('commit').trim()
                    sh "kubectl set image deployment/employee-mgmt-deployment emp-mgmt-app=${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_DEFAULT_REGION}.amazonaws.com/${IMAGE_REPO_NAME}:${IMAGE_TAG}${COMMIT_ID} -n demo"
                    sh "kubectl apply -f employee-mgmt-svc.yaml -n demo"
                }
			}
		}
    }
}
