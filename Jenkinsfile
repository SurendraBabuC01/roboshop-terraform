pipeline {

    agent {
        node {
            label 'workstation'
        }
    }

    options {
        ansiColor('xterm')
    }

    parameters {
        choice(name: 'env', choices: ['dev', 'prod'], description: 'Pick Environment')

        choice(name: 'action', choices: ['apply', 'destroy'], description: 'Pick Action')
    }

    stages {

        stage('terraform init') {
            steps {
                sh 'terraform init -backend-config=env-${env}/state.tfvars'
            }
        }

        stage('terraform ${action}') {
            steps {
                sh 'terraform ${action} -auto-approve -var-file=env-${env}/main.tfvars'
            }
        }
    }

    post {
        always {
            cleanWs()
        }
    }
}