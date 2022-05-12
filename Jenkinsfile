pipeline {
    agent {label 'mac_node'}
    stages {
        stage ('Init') {
            when {
                branch 'release*'
            }
            steps {
                echo 'testing the code'
                sh 'terraform init'
            }
        }
        stage ('Test code') {
            when {
                branch "test"
            }    
            steps {
            sh '''
            terraform init
            terraform plan
            '''
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
