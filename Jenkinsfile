pipeline {
    agent any

    stages {

        stage('Build') {
            steps {
                echo 'Building Docker image...'
                bat 'docker build -t simple-devops .'
            }
        }

        stage('Test') {
            steps {
                echo 'Docker image built successfully!'
                bat 'docker images simple-devops'
            }
        }
    }
}