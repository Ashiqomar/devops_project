pipeline {
    agent any

    environment {
        IMAGE = 'ghcr.io/ashiqomar/devops_project:latest'
    }

    stages {

        stage('Build') {
            steps {
                echo 'Building Docker image...'
                bat 'docker build -t simple-devops .'
            }
        }

        stage('Test') {
            steps {
                echo 'Testing Docker image...'
                bat 'docker images simple-devops'
            }
        }

        stage('Push to GHCR') {
            steps {
                withCredentials([usernamePassword(
                    credentialsId: 'github-ghcr',
                    usernameVariable: 'GHCR_USER',
                    passwordVariable: 'GHCR_TOKEN'
                )]) {
                    bat '''
                    echo %GHCR_TOKEN% | docker login ghcr.io -u %GHCR_USER% --password-stdin
                    docker tag simple-devops %IMAGE%
                    docker push %IMAGE%
                    '''
                }
            }
        }
    }

    post {
        always {
            bat 'docker logout ghcr.io'
        }
    }
}