pipeline {
    agent any

    environment {
        GIT_REPO = 'https://github.com/your-username/your-repo.git'
        BRANCH = 'main'
        SONAR_PROJECT_KEY = 'your-project-key'
        SONAR_HOST_URL = 'http://your-sonarqube-server'
        SONAR_TOKEN = credentials('sonarqube-token')
        DOCKER_IMAGE = 'your-dockerhub-username/your-image-name'
        REGISTRY_CREDENTIALS = 'docker-hub-credentials'
    }

    stages {
        stage('Clone Repository') {
            steps {
                git branch: "${BRANCH}", url: "${GIT_REPO}"
            }
        }

        stage('Build Project') {
            steps {
                sh 'mvn clean package'
            }
        }

        stage('SonarQube Analysis') {
            steps {
                withSonarQubeEnv('SonarQube') {
                    sh 'mvn sonar:sonar -Dsonar.projectKey=${SONAR_PROJECT_KEY} -Dsonar.host.url=${SONAR_HOST_URL} -Dsonar.login=${SONAR_TOKEN}'
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                sh 'docker build -t ${DOCKER_IMAGE}:latest .'
            }
        }

        stage('Push to Docker Hub') {
            steps {
                withDockerRegistry([credentialsId: "${REGISTRY_CREDENTIALS}", url: ""]) {
                    sh 'docker push ${DOCKER_IMAGE}:latest'
                }
            }
        }

        stage('Deploy Container') {
            steps {
                sh 'docker run -d --name my-app -p 8080:8080 ${DOCKER_IMAGE}:latest'
            }
        }
    }

    post {
        success {
            echo "Pipeline executed successfully!"
        }
        failure {
            echo "Pipeline failed!"
        }
    }
}
