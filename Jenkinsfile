pipeline {
    agent any

    environment {
        DOCKER_USER = "christienmushoriwa"
        APP_NAME = "todoback"
        IMAGE_TAG = "latest"
    }
    triggers{
        pollSCM('H/1 * * * *')
    }

    stages {
        stage('SCM Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/christien0/spring-backend.git'
            }
        }

        stage('Build and Test') {
            steps {
                bat 'mvn clean package'
            }
        }

        stage('Build Docker Image') {
            steps {
                bat 'docker build -t %DOCKER_USER%/%APP_NAME%:%IMAGE_TAG% .'
            }
        }

        stage('Login to Docker Hub') {
            steps {
                withCredentials([usernamePassword(
                    credentialsId: '0a380709-8b0b-433e-8371-0710dada08be',
                    usernameVariable: 'DOCKER_USER',
                    passwordVariable: 'DOCKER_PASS')]) {
                    bat 'echo %DOCKER_PASS% | docker login -u %DOCKER_USER% --password-stdin'
                }
            }
        }

        stage('Push Docker Image') {
            steps {
                bat 'docker push %DOCKER_USER%/%APP_NAME%:%IMAGE_TAG%'
            }
        }

        stage('Test Backend Health') {
            steps {
                script {
                    // Test that the backend starts correctly
                    bat '''
                        docker run -d --name test-backend -p 8080:8080 %DOCKER_USER%/%APP_NAME%:%IMAGE_TAG%
                        powershell -Command "Start-Sleep -Seconds 30"
                        curl -f http://localhost:8080/api/tutorials && echo Backend health check: PASSED || echo Backend health check: FAILED
                        docker stop test-backend
                        docker rm test-backend
                    '''
                }
            }
        }
    }
}