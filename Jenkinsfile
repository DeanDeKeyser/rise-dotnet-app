node {
    stage('Checkout') {
        checkout scm
    }
    stage('Preparation') {
        catchError(buildResult: 'SUCCESS') {
            sh 'docker stop riseserverrunning'
            sh 'docker rm riseserverrunning'
        }
    }
    stage('Build Image') {
        sh 'docker build -t rise-app:latest .'
    }
    stage('Deploy Container') {
        sh 'docker run -d -p 5051:5000 --name riseserverrunning rise-app:latest'
    }
    stage('Health Check') {
        sh 'sleep 6'
        sh 'curl -I http://localhost:5051'
    }
}