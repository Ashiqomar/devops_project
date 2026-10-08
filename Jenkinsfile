pipeline {
    agent any

    stages {

        stage('Clone') {
            steps {
                echo 'Cloning project from GitHub...'
                git branch: 'main',
                    url: 'https://github.com/Ashiqomar/devops_project.git'
            }
        }

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