// Using git within checkout
pipeline {
    agent any
    environment {
        PROJECT_NAME = 'jenkins_node_example'
        DISABLE_AUTH = 'true'
        DB_ENGINE    = 'sqlite'
    }
    def tag = sh(returnStdout: true, script: "git describe --abbrev=0 --tags | sed 's/* //'").trim()
    stages {
        stage('Build image') {
            steps {
                script {
                    def buildImage = sh "docker build -t ${env.PROJECT_NAME}:${NODE_LABELS}-${tag} ."
                }
            }
        }
        stage('Push images') {
            docker.withRegistry('https://gcr.io', 'gcr:google-container-registry-project') {
                myContainer.push("${buildImage}")
                myContainer.push("${tag}")
            }
        }
    }
}