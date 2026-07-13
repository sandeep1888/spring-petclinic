pipeline {
    agent any

    tools {
        jdk 'JDK21'
        maven 'Maven'
    }

    stages {

        stage('Checkout') {
            steps {
          //    git branch: 'main', url: 'https://github.com/sandeep1888/spring-petclinic.git'
                checkout scm
            }
        }
/*
        stage('Gitleaks Scan') {
            steps {
                sh '''
                    gitleaks detect \
                      --no-git \
                      --source . \
                      --report-format sarif \
                      --report-path gitleaks-report.sarif
                '''
            }
        }
*/

        stage('Semgrep Scan') {
        steps {
        sh '''
        semgrep scan \
        --config p/security-audit \
        --sarif \
        --output semgrep-report.sarif
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
        
    always {
        archiveArtifacts artifacts: 'semgrep-report.sarif',  
            
            /*semgrep-report.sarif,
            dependency-check-report.html,
            target/*.jar
        '''*/
            
            allowEmptyArchive: true
    }
    failure {
        /*
        sh '''
        curl -X POST \
        -u user:token \
        -H "Content-Type: application/json" \
        https://jira.company.com/rest/api/2/issue \
        -d @jira.json
        '''
        */
        echo "Build Failed"
    }
}
}
