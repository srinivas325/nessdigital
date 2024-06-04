pipeline {
    agent any
    // {
    //     docker {
    //         image 'hashicorp/terraform:latest'
    //         args '-u root:root'  // Run as root to avoid permission issues
    //     }
    // }

    parameters {
        string(name: 'AWS_REGION', defaultValue: 'us-west-2', description: 'AWS region to use')
        string(name: 'S3_BUCKET', defaultValue: 'your-terraform-state-bucket', description: 'S3 bucket for Terraform state')
        string(name: 'DYNAMODB_TABLE', defaultValue: 'your-terraform-lock-table', description: 'DynamoDB table for Terraform state locking')
        credentials(name: 'AWS_ACCESS_KEY_ID', description: 'AWS Access Key ID')
        credentials(name: 'AWS_SECRET_ACCESS_KEY', description: 'AWS Secret Access Key')
        string(name: 'bucket_name', defaultValue: 'my-example-bucket', description: 'Name of the S3 bucket to create')
    }

    environment {
        AWS_ACCESS_KEY_ID = credentials('AWS_ACCESS_KEY_ID')
        AWS_SECRET_ACCESS_KEY = credentials('AWS_SECRET_ACCESS_KEY')
        AWS_REGION = "${params.AWS_REGION}"
        S3_BUCKET = "${params.S3_BUCKET}"
        DYNAMODB_TABLE = "${params.DYNAMODB_TABLE}"
    }

    stages {
        stage('Checkout') {
            steps {
                // Checkout the repository containing the Terraform code
                git url: 'https://github.com/srinivas325/tf-state-s3.git', branch: 'main'
            }
        }

        stage('Terraform Init') {
            steps {
                script {
                    sh """
                    terraform init \
                    -backend-config="bucket=${S3_BUCKET}" \
                    -backend-config="key=path/to/your/terraform.tfstate" \
                    -backend-config="region=${AWS_REGION}" \
                    -backend-config="dynamodb_table=${DYNAMODB_TABLE}"
                    """
                }
            }
        }

        stage('Terraform Plan') {
            steps {
                script {
                    sh """
                    terraform plan -var 'bucket_name=${params.bucket_name}' -out=tfplan
                    """
                }
            }
        }

        stage('Terraform Apply') {
            steps {
                script {
                    sh 'terraform apply tfplan'
                }
            }
        }
    }

    post {
        always {
            // Clean up the workspace
            cleanWs()
        }
    }
}
