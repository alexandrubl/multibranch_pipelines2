#String gitCredentials = "GIT_credentials"
#String branchName = "release*"
#String repoUrl = "https://github.com/alexandrublg/exercises.git"
pipeline {
    agent {label 'mac_node'}
    stages {
        stage ('Init') {
            when {
                branch 'release*'
            }
            steps {

                sh 'terraform init'
            }
        }
        stage ('Test code') {
            when {
                branch "test"
            }    
            steps {
            sh 'terraform plan'
            }
        }
        stage ('Deploy env') {
            when {
                branch 'main'
            }
            steps {
                sh 'terraform apply --auto-approve'
                sleep time: 200, unit: 'SECONDS'
            }
        }
        stage ('Destroy env') {
            when {
                branch 'main'
            }
            steps {
                sh 'terraform destroy --auto-approve'
            }
        }
    }
}
