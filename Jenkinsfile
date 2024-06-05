pipeline {
    agent any
    parameters {
        choice(name: 'ACTION', choices: ['apply', 'destroy'], description: 'What action should Terraform take?')
    }

    environment {
        AWS_ACCESS_KEY_ID     = credentials('aws-access-key-id')
        AWS_SECRET_ACCESS_KEY = credentials('aws-secret-access-key')
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
                script {
                    // Wrapping in a node block to ensure proper context
                    node {
                        git branch: 'main', url: 'https://github.com/srinivas325/tf-state-s3.git'
                    }
                }
            }
        }

        stage('Terraform Init') {
        
                docker {
                    image 'hashicorp/terraform:latest'
                    args '-u root:root'
                }
    
            steps {
                script {
                    // Wrapping in a node block to ensure proper context
                    node {
                        sh """
                        terraform init -backend-config="bucket=${params.BUCKET_NAME}" \
                                       -backend-config="key=${params.ENVIRONMENT}/terraform.tfstate" \
                                       -backend-config="region=${params.AWS_REGION}" \
                                       -backend-config="dynamodb_table=${params.LOCK_TABLE_NAME}"
                        """
                    }
                }
            }
        }

        stage('Terraform Plan') {
            
                docker {
                    image 'hashicorp/terraform:latest'
                    args '-u root:root'
                }
        
            steps {
                script {
                    // Wrapping in a node block to ensure proper context
                    node {
                        sh """
                        terraform plan -var 'aws_region=${params.AWS_REGION}' \
                                       -var 'bucket_name=${params.BUCKET_NAME}' \
                                       -var 'environment=${params.ENVIRONMENT}' \
                                       -var 'lock_table_name=${params.LOCK_TABLE_NAME}' \
                                       -out=tfplan
                        """
                    }
                }
            }
        }

        stage('Terraform Apply') {
            
                docker {
                    image 'hashicorp/terraform:latest'
                    args '-u root:root'
                }

            steps {
                script {
                    // Wrapping in a node block to ensure proper context
                    node {
                        sh 'terraform apply -auto-approve tfplan'
                    }
                }
            }
        }
    }

    post {
        always {
            // Wrapping in a node block to ensure proper context
            node {
                cleanWs()
            }
        }
    }
}
