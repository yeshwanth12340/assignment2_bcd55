pipeline {
    agent any

    environment {
        DOCKER_IMAGE = "your-dockerhub-username/app-name"
        SONARQUBE_SERVER = "SonarQube"
    }

    stages {
        stage('Clone Repository') {
            steps {
                git 'https://github.com/your-repo/sample-project.git'
            }
        }

        stage('Build') {
            steps {
                script {
                    sh 'mvn clean package' // Change for Gradle/npm if needed
                }
            }
        }

        stage('SonarQube Analysis') {
            steps {
                script {
                    withSonarQubeEnv('SonarQube') {
                        sh 'mvn sonar:sonar' // Change for Gradle/npm if needed
                    }
                }
            }
        }

        stage('Docker Build') {
            steps {
                script {
                    sh 'docker build -t $DOCKER_IMAGE .'
                }
            }
        }

        stage('Docker Push') {
            steps {
                script {
                    sh 'echo $DOCKER_PASSWORD | docker login -u $DOCKER_USERNAME --password-stdin'
                    sh 'docker push $DOCKER_IMAGE'
                }
            }
        }

        stage('Deploy Container') {
            steps {
                script {
                    sh 'docker run -d -p 8080:8080 $DOCKER_IMAGE'
                }
            }
        }
    }
}
