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
                    [$class: 'AmazonWebServicesCredentialsBinding',
                     credentialsId: 'aws-terraform']
                ]) {
                    dir('terraform') {
                        bat '"%TERRAFORM%" init'
                    }
                }
            }
        }

        stage('Terraform Validate') {
            steps {
                withCredentials([
                    [$class: 'AmazonWebServicesCredentialsBinding',
                     credentialsId: 'aws-terraform']
                ]) {
                    dir('terraform') {
                        bat '"%TERRAFORM%" validate'
                    }
                }
            }
        }

        stage('Terraform Plan') {
            steps {
                withCredentials([
                    [$class: 'AmazonWebServicesCredentialsBinding',
                     credentialsId: 'aws-terraform']
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
                    [$class: 'AmazonWebServicesCredentialsBinding',
                     credentialsId: 'aws-terraform']
                ]) {
                    dir('terraform') {
                        bat '"%TERRAFORM%" apply -auto-approve'
                    }
                }
            }
        }

       stage('Deploy to EC2') {
    steps {
        withCredentials([
            sshUserPrivateKey(
                credentialsId: 'ec2-ssh',
                keyFileVariable: 'SSH_KEY',
                usernameVariable: 'SSH_USER'
            )
        ]) {
            dir('terraform') {
                bat '''
                for /f "delims=" %%i in ('"%TERRAFORM%" output -raw ec2_public_ip') do set "EC2_IP=%%i"

                echo Deploying to EC2: %EC2_IP%

                icacls "%SSH_KEY%" /inheritance:r
                icacls "%SSH_KEY%" /remove "BUILTIN\\Users"
                icacls "%SSH_KEY%" /grant:r "SYSTEM:R"

                ssh -o StrictHostKeyChecking=no -i "%SSH_KEY%" %SSH_USER%@%EC2_IP% "sudo dnf install -y docker && sudo systemctl enable docker && sudo systemctl start docker && sudo docker pull %IMAGE% && sudo docker stop simple-devops || true && sudo docker rm simple-devops || true && sudo docker run -d --name simple-devops --restart unless-stopped -p 80:80 %IMAGE%"
                '''
            }
        }
    }
}