pipeline {
    agent any

    environment {
        AZURE_CREDENTIALS = credentials('azure-sp-credentials') // Use Jenkins Credentials ID
    }

    stages {
        stage('Checkout Code') {
            steps {
                git 'https://github.com/pranaydakuri/Jenkins_repo.git' // Replace with your repo
            }
        }

        stage('Setup Azure Login') {
            steps {
                script {
                    def creds = readJSON text: AZURE_CREDENTIALS
                    sh """
                        az login --service-principal -u ${creds.clientId} -p ${creds.clientSecret} --tenant ${creds.tenantId}
                    """
                }
            }
        }

        stage('Terraform Init') {
            steps {
                sh 'terraform init'
            }
        }

        stage('Terraform Plan') {
            steps {
                sh 'terraform plan -var="subscription_id=${creds.subscriptionId}" -var="client_id=${creds.clientId}" -var="client_secret=${creds.clientSecret}" -var="tenant_id=${creds.tenantId}" -out=tfplan'
            }
        }

        stage('Terraform Apply') {
            steps {
                sh 'terraform apply -auto-approve tfplan'
            }
        }
    }
}
