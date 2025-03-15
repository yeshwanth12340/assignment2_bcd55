pipeline {
    agent any

    environment {
        SONARQUBE_SERVER = 'SonarQube' // Update with your SonarQube server name in Jenkins
        DOCKER_IMAGE = 'yeshwanth12340/assignment2_bcd55:latest' // Change accordingly
    }

    stages {

        // Step 1: Clone Git Repository
        stage('Clone Repository') {
            steps {
                git credentialsId: '090d0633-eaf0-439f-97b2-e257f3f40897', 
                    url: 'https://github.com/yeshwanth12340/assignment2_bcd55.git', 
                    branch: 'main'
            }
        }

        // Step 2: Build with Maven
        stage('Build') {
            steps {
                script {
                    sh 'mvn clean package' // Runs Maven build
                }
            }
        }

        // Step 3: SonarQube Code Analysis
        stage('SonarQube Analysis') {
            steps {
                script {
                    withSonarQubeEnv(SONARQUBE_SERVER) {
                        sh 'mvn sonar:sonar' // Run SonarQube scan
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

        // Step 5: Docker Push (Requires Docker Hub Login)
        stage('Docker Push') {
            steps {
                script {
                    sh "docker login -u your-docker-username -p your-docker-password"
                    sh "docker push ${DOCKER_IMAGE}"
                }
            }
        }

        // Step 6: Deploy the Docker Container
        stage('Deploy Container') {
            steps {
                script {
                    sh "docker run -d -p 8080:8080 ${DOCKER_IMAGE}"
                }
            }
        }
    }
    
    // Optional: Post-Build Cleanup and Notifications
    post {
        success {
            echo 'Pipeline executed successfully!'
        }
        failure {
            echo 'Pipeline failed. Please check the logs.'
        }
    }
}
