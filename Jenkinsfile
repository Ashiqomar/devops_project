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

                ssh -o StrictHostKeyChecking=no -i "%SSH_KEY%" %SSH_USER%@%EC2_IP% "sudo docker pull %IMAGE% && sudo docker stop simple-devops || true && sudo docker rm simple-devops || true && sudo docker run -d --name simple-devops --restart unless-stopped -p 80:80 %IMAGE%"
                '''
            }
        }
    }
}