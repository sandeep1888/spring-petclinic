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


        stage('Semgrep Scan') {
    steps {
        sh '''
        /opt/semgrep/venv/bin/semgrep scan \
          --config p/security-audit \
          --sarif \
          --output semgrep-report.sarif
        '''
    }
}
*/
        stage('Semgrep Scan') {
    steps {
        sh '''
        mkdir -p /tmp/semgrep

        /opt/semgrep/venv/bin/semgrep scan \
          --config p/security-audit \
          --sarif \
          --output /tmp/semgrep/semgrep-report.sarif
        '''
    }
}

/*        
       stage('OWASP Dependency Check') {
    steps {
        catchError(buildResult: 'SUCCESS', stageResult: 'UNSTABLE') {
            sh '''
            mkdir -p dependency-check-report

            /opt/dependency-check-tool/bin/dependency-check.sh \
            --project "spring-petclinic" \
            --scan pom.xml \
            --format HTML \
            --out dependency-check-report \
            --noupdate
            '''
        }
    }
}
*/

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

        stage('Unit Test') {
            steps {
                sh 'mvn test'
            }
            post {
                always {
                    junit 'target/surefire-reports/*.xml'
                }
            }
        }

        stage('Build') {
            steps {
                sh 'mvn clean package -DskipTests -Dcheckstyle.skip=true'
            }
        }

    }
    post {
        
    always {

        sh '''
        if [ -f /tmp/semgrep/semgrep-report.sarif ]; then
            cp /tmp/semgrep/semgrep-report.sarif .
        fi
    '''
       // sh 'cp /tmp/semgrep/semgrep-report.sarif . || true'
       // archiveArtifacts artifacts: 'semgrep-report.sarif',  
            
            /*semgrep-report.sarif,
            dependency-check-report.html,
            target/*.jar
        '''*/

         archiveArtifacts( 
             artifacts: '''
                semgrep-report.sarif,
       //     dependency-check-report/**
                target/*.jar,
                target/site/jacoco/**
        ''',
                 allowEmptyArchive: true
            
         )
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
