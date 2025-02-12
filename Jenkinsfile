pipeline {
    agent any

    environment {
        AZURE_CREDENTIALS = credentials('azure-sp-credentials') // Jenkins Credentials ID
    }

    stages {
        stage('Checkout Code') {
            steps {
                git branch: 'main', url: 'https://github.com/pranaydakuri/Jenkins_repo.git' // Explicitly specifying branch
            }
        }

        stage('Setup Azure Login') {
            steps {
                script {
                    withCredentials([string(credentialsId: 'azure-sp-credentials', variable: 'AZURE_CREDENTIALS')]) {
                        def creds = readJSON text: AZURE_CREDENTIALS
                        sh """
                            az login --service-principal -u ${creds.clientId} -p ${creds.clientSecret} --tenant ${creds.tenantId}
                        """
                    }
                }
            }
        }

        stage('Terraform Init') {
            steps {
                script {
                    sh 'terraform init || exit 1' // Exit if init fails
                }
            }
        }

        stage('Terraform Plan') {
            steps {
                script {
                    withCredentials([string(credentialsId: 'azure-sp-credentials', variable: 'AZURE_CREDENTIALS')]) {
                        def creds = readJSON text: AZURE_CREDENTIALS
                        sh """
                            terraform plan -var="subscription_id=${creds.subscriptionId}" \
                                           -var="client_id=${creds.clientId}" \
                                           -var="client_secret=${creds.clientSecret}" \
                                           -var="tenant_id=${creds.tenantId}" \
                                           -out=tfplan || exit 1
                        """
                    }
                }
            }
        }

        stage('Terraform Apply') {
            steps {
                script {
                    sh 'terraform apply -auto-approve tfplan || exit 1' // Exit if apply fails
                }
            }
        }
    }
}
