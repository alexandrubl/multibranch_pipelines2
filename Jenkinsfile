pipeline {
    agent {label 'mac_node'}
    stages {
        stage ('Hello') {
            steps {
                echo "Hello"
            }
        }
        stage ('Read file') {
            when {
                branch "release"
            }    
            steps {
            sh 'cat README.md'
        }
        }
    }
}
