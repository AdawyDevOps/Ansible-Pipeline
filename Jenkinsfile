pipeline {
    agent any

    stages {
        stage('Run Ansible Playbook') {
            steps {
                sh 'ansible-playbook -i inventory.ini playbook.yml'
            }
        }
    }

    post {
        success {
            echo 'Nginx installed and running successfully.'
        }
        failure {
            echo 'Pipeline failed. Check the Console Output.'
        }
        always {
            echo 'Pipeline finished.'
        }
    }
}