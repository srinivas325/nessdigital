pipeline {
    agent any
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


        stage('Configure AWS Credentials') {
            agent any
            steps {
                withCredentials([[
                $class: 'AmazonWebServicesCredentialsBinding',
                accessKeyVariable: 'AWS_ACCESS_KEY_ID',
                secretKeyVariable: 'AWS_SECRET_ACCESS_KEY',
                credentialsId: 'AWS-Creds']]) 
                {
                    script 
                    {
                        sh 'aws configure set aws_access_key_id $AWS_ACCESS_KEY_ID'
                        sh 'aws configure set aws_secret_access_key $AWS_SECRET_ACCESS_KEY'
                        sh 'aws sts get-caller-identity'
                    }
                }
            }
        }
    
        stage('Terraform Init') {
            agent any
            steps {
                script {
                    sh 'terraform init -no-color'
                              }
        }
    }

        stage('Terraform Plan') {
            agent any
            steps {


                script {
                    sh 'terraform plan -no-color -input=false -out=tfplan -var "aws_region=${AWS_REGION}" var "environment=${ENVIRONMENT}" '
            }
            }
    }
    stage('Approval') {
      steps {
        script {
          def userInput = input(id: 'confirm', message: 'Apply Terraform?', parameters: [ [$class: 'BooleanParameterDefinition', defaultValue: false, description: 'Apply terraform', name: 'confirm'] ])
        }
      }
    }
    stage('Terraform Apply') {
            agent any
            steps {
                script {
                    sh 'terraform apply -input=false myplan'
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
