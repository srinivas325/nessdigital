pipeline {
    agent none

    // environment {
    //     AWS_ACCESS_KEY_ID     = credentials('aws-access-key-id')
    //     AWS_SECRET_ACCESS_KEY = credentials('aws-secret-access-key')
    // }

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
                git branch: 'main', url: 'https://github.com/srinivas325/tf-state-s3.git'
            }
        }
        stage('Terraform init') {
            agent any
            steps {
                script {
                    sh 'terraform init'
                    sh 'terraform validate'
            }
        }
    }
}
}
