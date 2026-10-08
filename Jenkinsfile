pipeline {
    agent any

    environment {
        IMAGE = 'ghcr.io/ashiqomar/devops_project:latest'
        TERRAFORM = 'C:\\Users\\Ashiq\\AppData\\Local\\Microsoft\\WinGet\\Links\\terraform.exe'
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

                withCredentials([
                    usernamePassword(
                        credentialsId: 'github-ghcr',
                        usernameVariable: 'GHCR_USER',
                        passwordVariable: 'GHCR_TOKEN'
                    )
                ]) {

                    bat '''
                    echo %GHCR_TOKEN% | docker login ghcr.io -u %GHCR_USER% --password-stdin
                    docker tag simple-devops %IMAGE%
                    docker push %IMAGE%
                    '''
                }
            }
        }

        stage('Terraform Init') {
            steps {

                withCredentials([
                    usernamePassword(
                        credentialsId: 'aws-terraform',
                        usernameVariable: 'AWS_ACCESS_KEY_ID',
                        passwordVariable: 'AWS_SECRET_ACCESS_KEY'
                    )
                ]) {

                    dir('terraform') {

                        bat '"%TERRAFORM%" init'
                    }
                }
            }
        }

        stage('Terraform Validate') {
            steps {

                dir('terraform') {

                    bat '"%TERRAFORM%" validate'
                }
            }
        }

        stage('Terraform Plan') {
            steps {

                withCredentials([
                    usernamePassword(
                        credentialsId: 'aws-terraform',
                        usernameVariable: 'AWS_ACCESS_KEY_ID',
                        passwordVariable: 'AWS_SECRET_ACCESS_KEY'
                    )
                ]) {

                    dir('terraform') {

                        bat '"%TERRAFORM%" plan'
                    }
                }
            }
        }

        stage('Terraform Apply') {
            steps {

                withCredentials([
                    usernamePassword(
                        credentialsId: 'aws-terraform',
                        usernameVariable: 'AWS_ACCESS_KEY_ID',
                        passwordVariable: 'AWS_SECRET_ACCESS_KEY'
                    )
                ]) {

                    dir('terraform') {

                        bat '"%TERRAFORM%" apply -auto-approve'
                    }
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