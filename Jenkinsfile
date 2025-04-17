pipeline {
    agent { label 'kube' }
    environment {
        SONAR_URL = "http://3.149.4.43:9000"
        PATH = "/opt/sonar-scanner/bin:$PATH"
    }
    stages {
        stage('Checkout Code') {
            steps {
                git branch: 'main', url: 'https://github.com/ajjurathod/ci-cd-pipeline.git'
            }
        }
        stage('Static Code Analysis') {
            steps {
                withCredentials([string(credentialsId: 'sonarqube', variable: 'SONAR_AUTH_TOKEN')]) {
                    sh '''
                        sonar-scanner \
                        -Dsonar.projectKey=ci-cd-pipeline \
                        -Dsonar.sources=. \
                        -Dsonar.host.url=$SONAR_URL \
                        -Dsonar.login=$SONAR_AUTH_TOKEN
                    '''
                }
            }
        }
        stage('Build Docker Image') {
            steps {
                sh 'docker build -t ajjurathod1998/pipeline .'
            }
        }
        stage('Push to DockerHub') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'docker-hub', usernameVariable: 'DOCKER_USERNAME', passwordVariable: 'DOCKER_PASSWORD')]) {
                    sh '''
                        echo "$DOCKER_PASSWORD" | docker login -u "$DOCKER_USERNAME" --password-stdin
                        docker push ajjurathod1998/pipeline
                    '''
                }
            }
        }
        stage('Deploy to QA') {
            steps {
                sh 'kubectl apply -f deploy/qa-deployment.yaml'
            }
        }
        stage('Deploy to UAT') {
            steps {
                input message: "Proceed to deploy to UAT?"
                sh 'kubectl apply -f deploy/uat-deployment.yaml'
            }
        }
        stage('Deploy to Pre-Prod') {
            steps {
                input message: "Proceed to deploy to Pre-Prod?"
                sh 'kubectl apply -f deploy/preprod-deployment.yaml'
            }
        }
        stage('Deploy to Production') {
            steps {
                input message: "Final approval for Production?"
                sh 'kubectl apply -f deploy/prod-deployment.yaml'
            }
        }
    }
}
