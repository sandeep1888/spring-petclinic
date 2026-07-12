pipeline {
    agent any

    tools {
        jdk 'JDK17'
        maven 'Maven'
    }

    stages {

        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/sandeep1888/spring-petclinic.git'
            }
        }

        stage('Gitleaks Scan') {
            steps {
                sh '''
                    gitleaks detect \
                      --source . \
                      --report-format sarif \
                      --report-path gitleaks-report.sarif
                '''
            }
        }

        stage('Java Version') {
            steps {
                sh 'java -version'
            }
        }

        stage('Maven Version') {
            steps {
                sh 'mvn -version'
            }
        }

        stage('Build') {
            steps {
                sh 'mvn clean package'
            }
        }

    }
    post {
    failure {
        sh '''
        curl -X POST \
        -u user:token \
        -H "Content-Type: application/json" \
        https://jira.company.com/rest/api/2/issue \
        -d @jira.json
        '''
    }
}
}
