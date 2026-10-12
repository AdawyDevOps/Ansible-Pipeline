pipeline {
    agent any

    stages {
        stage('Deploy Nginx with Ansible') {
            steps {
                withCredentials([sshUserPrivateKey(credentialsId: 'local-ssh-key', keyFileVariable: 'SSH_KEY', usernameVariable: 'SSH_USER')]) {
                    sh '''
                        echo "Configuring SSH key permissions..."
                        chmod 400 "$SSH_KEY"

                        echo "Running Ansible Playbook..."
                        ansible-playbook -i inventory.ini install_nginx.yml \
                          --private-key "$SSH_KEY" \
                          -u "$SSH_USER"
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
