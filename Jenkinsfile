pipeline {
    agent any
    environment {
        AWS_DEFAULT_REGION        = 'us-east-1'       // Primary region
        SECONDARY_REGION          = 'us-west-2'       // Secondary region
        TERRAFORM_DIR             = 'terraform'
        TF_VAR_S3_PRIMARY_PREFIX   = 'primary-vr'
        TF_VAR_S3_SECONDARY_PREFIX = 'secondary-vr'
    }

    stages {
        stage('Checkout') {
            steps {
                // Make sure this repo contains the terraform folder and scripts
                git branch: 'main', url: 'https://github.com/VR-123-v/test-1.git'
            }
        }

        stage('Terraform Init') {
            steps {
                dir("${env.TERRAFORM_DIR}") {
                    sh 'terraform init'
                }
            }
        }

        stage('Terraform Plan') {
            steps {
                dir("${env.TERRAFORM_DIR}") {
                    sh 'terraform plan -out=tfplan'
                }
            }
        }

        stage('Terraform Apply') {
            steps {
                dir("${env.TERRAFORM_DIR}") {
                    sh 'terraform apply -auto-approve tfplan'
                }
            }
        }

        stage('Sync Web Content to S3') {
            steps {
                dir("${env.TERRAFORM_DIR}/scripts") {
                    sh './s3-sync.sh'
                }
            }
        }

        stage('Trigger Failover Check') {
            steps {
                dir("${env.TERRAFORM_DIR}/scripts") {
                    sh './failover.sh'
                }
            }
        }
    }

    post {
        success {
            echo 'Deployment completed successfully!'
        }
        failure {
            echo 'Pipeline failed. Check Jenkins console output for details.'
        }
    }
}
