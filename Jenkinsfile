pipeline {
    agent any

    tools {
        maven 'Maven3'  // Ensure this matches the configured Maven installation in Jenkins
    }

    environment {
        SONARQUBE_SERVER = 'SonarQube'  // Match the name configured in Jenkins
        DOCKER_IMAGE = 'yeshwanth12340/assignment2_bcd55:latest' // Adjust as needed
    }

    stages {

        // Step 1: Clone Git Repository
        stage('Clone Repository') {
            steps {
                git credentialsId: 'github-credentials', 
                    url: 'https://github.com/yeshwanth12340/assignment2_bcd55.git', 
                    branch: 'main'
            }
        }

        // Step 2: Build with Maven
        stage('Build') {
            steps {
                sh 'mvn clean package'  // Runs Maven build
            }
        }

        // Step 3: SonarQube Code Analysis
        stage('SonarQube Analysis') {
            steps {
                script {
                    withSonarQubeEnv('SonarQube') {
                        sh 'mvn sonar:sonar -Dsonar.projectKey=assignment2_bcd55 -Dsonar.host.url=http://localhost:9000'
                    }
                }
            }
        }

        // Step 4: Docker Build
        stage('Docker Build') {
            steps {
                script {
                    sh "docker build -t ${DOCKER_IMAGE} ."
                }
            }
        }

        // Step 5: Docker Push (Uses Jenkins Credentials)
        stage('Docker Push') {
            steps {
                script {
                    withDockerRegistry([credentialsId: 'docker-hub-credentials', url: '']) {
                        sh "docker push ${DOCKER_IMAGE}"
                    }
                }
            }
        }

        // Step 6: Deploy the Docker Container
        stage('Deploy Container') {
            steps {
                script {
                    sh "docker run -d -p 8080:8080 --name assignment-container ${DOCKER_IMAGE}"
                }
            }
        }
    }
    
    post {
        success {
            echo 'Pipeline executed successfully! ✅'
        }
        failure {
            echo 'Pipeline failed. Please check the logs. ❌'
        }
    }
}
