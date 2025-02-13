pipeline {
    agent any
 
    environment {
        ARM_CLIENT_ID = credentials('ARM_CLIENT_ID')
        ARM_CLIENT_SECRET = credentials('ARM_CLIENT_SECRET')
        ARM_SUBSCRIPTION_ID = credentials('ARM_SUBSCRIPTION_ID')
        ARM_TENANT_ID = credentials('ARM_TENANT_ID')
    }
 
    stages {
        stage('Terraform Init') {
            steps {
                terraformInit()
            }
        }
        stage('Terraform Plan') {
            steps {
                terraformPlan(
                    args: '-var="client_id=${ARM_CLIENT_ID}" -var="client_secret=${ARM_CLIENT_SECRET}" -var="subscription_id=${ARM_SUBSCRIPTION_ID}" -var="tenant_id=${ARM_TENANT_ID}"'
                )
            }
        }
        stage('Terraform Apply') {
            steps {
                terraformApply(
                    args: '-auto-approve -var="client_id=${ARM_CLIENT_ID}" -var="client_secret=${ARM_CLIENT_SECRET}" -var="subscription_id=${ARM_SUBSCRIPTION_ID}" -var="tenant_id=${ARM_TENANT_ID}"'
                )
            }
        }
    }
}
