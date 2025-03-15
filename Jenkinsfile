pipeline {
    agent any

    tools {
        maven 'Maven3'  // Ensure Maven is configured in Jenkins
    }

    environment {
        SONARQUBE_SERVER = 'SonarQube'  // Matches Jenkins SonarQube configuration
        DOCKER_IMAGE = 'yeshwanth12340/assignment2_bcd55:latest' // Docker image name
        DOCKER_PATH = '/usr/local/bin/docker'  // Check with `which docker`
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
                sh 'mvn clean package'  // Runs Maven build
            }
        }

        // Step 3: SonarQube Code Analysis
       stage('SonarQube Analysis') {
    steps {
        script {
            withSonarQubeEnv('SonarQube') {  // Ensure 'SonarQube' matches Jenkins' SonarQube server name
                withCredentials([string(credentialsId: 'sonar-token', variable: 'SONAR_TOKEN')]) {
                    sh 'mvn sonar:sonar -Dsonar.projectKey=assignment2_bcd55 -Dsonar.host.url=http://localhost:9000 -Dsonar.login=$SONAR_TOKEN'
                     }
                  }
               }
            }
        }


        // Step 4: Docker Build
        stage('Docker Build') {
            steps {
                script {
                    sh '${DOCKER_PATH} build -t ${DOCKER_IMAGE} .'
                }
            }
        }

        // Step 5: Docker Push (Uses Jenkins Credentials)
        stage('Docker Push') {
            steps {
                script {
                    withDockerRegistry([credentialsId: 'docker-hub-credentials', url: 'https://index.docker.io/v1/']) {
                        sh "${DOCKER_PATH} push ${DOCKER_IMAGE}"
                    }
                }
            }
        }

        // Step 6: Deploy the Docker Container
        stage('Deploy Container') {
            steps {
                script {
                    sh """
                    ${DOCKER_PATH} stop assignment-container || true
                    ${DOCKER_PATH} rm assignment-container || true
                    ${DOCKER_PATH} run -d -p 8080:8080 --name assignment-container ${DOCKER_IMAGE}
                    """
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
