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


        stage('AWS') {
            steps {
                // Use the withCredentials block to access AWS credentials securely
                withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'AWS-Creds', accessKeyVariable: 'AWS_ACCESS_KEY_ID', secretKeyVariable: 'AWS_SECRET_ACCESS_KEY']]) 
                {
                    sh 'aws sts get-caller-idenntity' // Example command using AWS CLI
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
}
