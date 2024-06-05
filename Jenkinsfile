pipeline {
    agent any
    parameters {
        choice(name: 'ACTION', choices: ['apply', 'destroy'], description: 'What action should Terraform take?')
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
            steps {
                script {
                    // Wrapping in a node block to ensure proper context
                    node {
sh """
docker run --rm -v \$(pwd):/workspace -w /workspace hashicorp/terraform:latest plan -var 'aws_region=\${params.AWS_REGION}' \
                               -var 'bucket_name=\${params.BUCKET_NAME}' \
                               -var 'environment=\${params.ENVIRONMENT}' \
                               -var 'lock_table_name=\${params.LOCK_TABLE_NAME}' \
                               -out=tfplan
"""

                }
            }
        }

        stage('Terraform Plan') {
            steps {
                script {
                    // Wrapping in a node block to ensure proper context
                    node {
                        sh """
                        docker run --rm -v $(pwd):/workspace -w /workspace hashicorp/terraform:latest plan -var 'aws_region=${params.AWS_REGION}' \
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
            steps {
                script {
                    // Wrapping in a node block to ensure proper context
                    node {
                        sh 'docker run --rm -v $(pwd):/workspace -w /workspace hashicorp/terraform:latest apply -auto-approve tfplan'
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
