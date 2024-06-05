pipeline {
    agent none
    parameters {
        string(name: 'AWS_REGION', defaultValue: 'us-west-2', description: 'AWS region to use')
        string(name: 'BUCKET_NAME', defaultValue: 'my-terraform-state-bucket', description: 'S3 bucket for Terraform state')
        string(name: 'ENVIRONMENT', defaultValue: 'development', description: 'Environment for the resources')
        string(name: 'LOCK_TABLE_NAME', defaultValue: 'terraform-state-lock', description: 'DynamoDB table for Terraform state locking')
    }

    stages {
        stage('Checkout') {
            agent any
            steps {
                git branch: 'main', url: 'https://github.com/srinivas325/nessdigital.git'
            }
        }
    }

    stages {
        stage('AWS') {
            agent any
            steps {
             withAWS(credentials: 'AWS-Creds', region: 'us-west-2') {
                    sh 'aws sts get-caller-identity'              
                }
            }
        }
    }
        stage('terraform init') {
            agent any
            steps {
                script {
                    sh 'terraform init'
                    sh 'terraform validate'
            }
        }
    }
        stage('terraform validate') {
            agent any
            steps {
                script {
                    sh 'terraform validate'
            }
        }
    }
        stage('terraform plan') {
            agent any
            steps {
                script {
                    sh 'terraform plan'
            }
        }
    }
}
