pipeline {
    agent {
        docker {
            image 'hashicorp/terraform:latest'
            args '-u root:root'  // Run as root to avoid permission issues
        }
    }

    environment {
        AWS_ACCESS_KEY_ID     = credentials('aws-access-key-id')
        AWS_SECRET_ACCESS_KEY = credentials('aws-secret-access-key')
        AWS_REGION            = 'us-west-2'
    }

    parameters {
        string(name: 'AWS_REGION', defaultValue: 'us-west-2', description: 'AWS region to use')
        string(name: 'BUCKET_NAME', defaultValue: 'my-terraform-state-bucket', description: 'S3 bucket for Terraform state')
        string(name: 'ENVIRONMENT', defaultValue: 'development', description: 'Environment for the resources')
        string(name: 'LOCK_TABLE_NAME', defaultValue: 'terraform-state-lock', description: 'DynamoDB table for Terraform state locking')
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/your-repo/terraform-config.git'
            }
        }

        stage('Terraform Init') {
            steps {
                script {
                    sh """
                    terraform init -backend-config="bucket=${params.BUCKET_NAME}" -backend-config="key=${params.ENVIRONMENT}/terraform.tfstate" -backend-config="region=${params.AWS_REGION}" -backend-config="dynamodb_table=${params.LOCK_TABLE_NAME}"
                    """
                }
            }
        }

        stage('Terraform Plan') {
            steps {
                script {
                    sh """
                    terraform plan -var 'aws_region=${params.AWS_REGION}' -var 'bucket_name=${params.BUCKET_NAME}' -var 'environment=${params.ENVIRONMENT}' -var 'lock_table_name=${params.LOCK_TABLE_NAME}' -out=tfplan
                    """
                }
            }
        }

        stage('Terraform Apply') {
            steps {
                script {
                    sh 'echo terraform apply'
                }
            }
        }
    }

    post {
        always {
            cleanWs()
        }
    }
}
