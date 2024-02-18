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
    }

    stages {

        stage('terraform init') {
            steps {
                sh 'terraform init -backend-config=env-${env}/state.tfvars'
            }
        }

        stage('terraform apply') {
            steps {
                sh 'terraform apply -auto-approve -var-file=env-${env}/main.tfvars'
            }
        }
    }

    post {
        always {
            cleanWs()
        }
    }
}