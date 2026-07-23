
pipeline {
    agent any

    tools {
        jdk 'JDK21'
        maven 'Maven'
    }

    environment {
        IMAGE_NAME = 'spring-petclinic'
        IMAGE_TAG = "${BUILD_NUMBER}"
        IMAGE = "${IMAGE_NAME}:${IMAGE_TAG}"
    }

    stages {

        stage('Checkout') {
            steps {
                deleteDir()
                checkout scm
            }
        }

        stage('Docker Check') {
    steps {
        sh '''
            echo "Running as:"
            whoami

            echo "Docker path:"
            which docker

            echo "Docker version:"
            docker --version

            echo "Docker Compose version:"
            docker compose version
        '''
    }
}

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

        stage('Start Test Dependencies') {
    steps {
        sh '''
            docker compose up -d postgres

            echo "Waiting for PostgreSQL..."

            for i in {1..30}; do
                if docker exec full-postgres-1 pg_isready -U petclinic -d petclinic > /dev/null 2>&1; then
                    echo "PostgreSQL is ready!"
                    break
                fi

                echo "PostgreSQL not ready yet..."
                sleep 2
            done

            docker compose ps
        '''
    }
}

        stage('Unit Test') {
            steps {
                sh 'mvn test -Dcheckstyle.skip=true'
            }

            post {
                always {
                    junit(
                        testResults: 'target/surefire-reports/*.xml',
                        allowEmptyResults: true
                    )
                }
            }
        }

        stage('Stop Test Dependencies') {
    steps {
        sh '''
            docker compose down
        '''
    }
}

        stage('Build JAR') {
            steps {
                sh 'mvn clean package -DskipTests -Dcheckstyle.skip=true'
            }
        }

        stage('Docker Image Build') {
            steps {
                sh 'docker build -t ${IMAGE} .'
            }
        }

        stage('Docker Image Test') {
    steps {
        sh '''
            docker run -d \
              --name spring-petclinic-test \
              -p 18080:8080 \
              ${IMAGE}
        '''

        echo 'Waiting for application to start...'

        sleep 15

        sh 'docker ps'

        sh 'curl -f http://localhost:18080/'
    }

    post {
        always {
            sh '''
                docker logs spring-petclinic-test || true
                docker stop spring-petclinic-test || true
                docker rm spring-petclinic-test || true
            '''
        }
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

            archiveArtifacts(
                artifacts: '''
                    semgrep-report.sarif,
                    target/*.jar,
                    target/site/jacoco/**
                ''',
                allowEmptyArchive: true
            )
        }

        failure {
            echo 'Build Failed'
        }
    }
}
