pipeline {
    agent any

    stages {
        stage('Deploy Nginx with Ansible') {
            steps {
                sshagent(['local-ssh-key']) {
                    sh '''
                        echo "Running Ansible Playbook..."
                        ansible-playbook -i inventory.ini install_nginx.yml
                    '''
                }
            }
        }
    }

    post {
        success {
            echo "Nginx successfully installed and running on the host machine!"
        }
        failure {
            echo "Ansible deployment failed. Check the logs above."
        }
    }
}
