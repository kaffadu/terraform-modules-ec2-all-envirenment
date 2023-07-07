pipeline {
    agent any
    tools {
        terraform 'Terraform'
    }

    stages {
    stage('Checkout') {
        steps {
        // Checkout the repository with Git
        git 'https://github.com/kaffadu/terraform-modules-ec2-all-envirenment.git'
        }
        }

    stage('Terraform Init') {
        steps {
        // Go to the repository directory
        dir('terraform-modules-ec2-all-envirenment') {
          // Run 'terraform init' command
            sh 'terraform init'
        }
        }
        }

    stage('Terraform Apply') {
        steps {
        // Go to the repository directory
        dir('terraform-modules-ec2-all-envirenment') {
          // Run 'terraform apply' command with 'prod.tfvars'
            sh 'terraform apply -var-file=prod.tfvars'
        }
        }
        }
    }
}
