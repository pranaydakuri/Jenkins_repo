pipeline {
    agent any
    environment {
        ARM_CLIENT_ID       = credentials('ARM_CLIENT_ID')
        ARM_CLIENT_SECRET   = credentials('ARM_CLIENT_SECRET')
        ARM_SUBSCRIPTION_ID = credentials('ARM_SUBSCRIPTION_ID')
        ARM_TENANT_ID       = credentials('ARM_TENANT_ID')
    }
 
    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/pranaydakuri/Jenkins_repo.git' // Explicitly specifying branch
            }
        }
        stage('Terraform Init') {
            steps {
                bat 'C:\\Terraform\\terraform.exe init'
            }
        }
 
        stage('Terraform Plan') {
    steps {
        bat 'C:\\Terraform\\terraform.exe plan'
    }
}

stage('Terraform Apply') {
    steps {
        bat 'C:\\Terraform\\terraform.exe apply -auto-approve'
    }
}
        
    }
}
