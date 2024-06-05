pipeline {
    agent any
    parameters {
        choice(name: 'ACTION', choices: ['apply', 'destroy'], description: 'What action should Terraform take?')
    }
environment {
    AWS_DEFAULT_REGION = 'us-west-2' // Specify your region
    BUCKET_NAME = 'your-unique-bucket-name' // Specify your unique bucket name
    AWS_CREDENTIALS_ID = 'aws-credentials-id' // Specify your AWS credentials ID
}
    stages {
        stage('Terraform') {
            steps {
                script {
                         {
                            sh 'terraform init'
                            sh 'terraform validate'
                            sh "terraform ${params.ACTION} -auto-approve"
                            if (params.ACTION == 'apply') {
                            sh "terraform ${params.ACTION} -auto-approve"
                          
                            }
                        }
                }
            }
        }
        stage('Delay') {
            when {
                expression { params.ACTION == 'apply' }
            }
            steps {
                script {
                    echo 'Waiting for SSH agent...'
                    sleep 120 // waits for 120 seconds before continuing
                }
            }
        }
        stage('Ansible') {
            when {
                expression { params.ACTION == 'apply' }
            }
            steps {
                withCredentials([sshUserPrivateKey(credentialsId: 'sshCredentials', keyFileVariable: 'SSH_KEY', usernameVariable: 'SSH_USER')]) {
                    dir('Ansible') {
                        sh "ansible-playbook -i inventory appPlaybook.yaml --private-key=$SSH_KEY -u $SSH_USER"
                    }
                }
            }
        }
        stage('Output URLs') {
            when {
                expression { params.ACTION == 'apply' }
            }
            steps {
                script {
                    def ip_address = sh(script: 'terraform -chdir=Terraform output -raw public_ip', returnStdout: true).trim()
                    def grafana_url = "http://${ip_address}:3000"
                    def prometheus_url = "http://${ip_address}:9090"
                    echo "Grafana URL: ${grafana_url}"
                    echo "Prometheus URL: ${prometheus_url}"
                    writeFile file: 'urls.txt', text: "Grafana URL: ${grafana_url}\nPrometheus URL: ${prometheus_url}"
                }
            }
        }
        stage('Archive URLs') {
            when {
                expression { params.ACTION == 'apply' }
            }
            steps {
                archiveArtifacts artifacts: 'urls.txt', onlyIfSuccessful: true
            }
        }
    }
}
