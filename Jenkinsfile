// Using git within checkout
pipeline {
    agent any
    environment {
        PROJECT_NAME = 'jenkins_node_example'
        DISABLE_AUTH = 'true'
        DB_ENGINE    = 'sqlite'
    }
    stages {
        stage('Build image') {
            steps {
                script {
                    def tag = sh(returnStdout: true, script: "git describe --abbrev=0 --tags | sed 's/* //'").trim()
                    buildImage = docker.build("${env.PROJECT_NAME}:${NODE_LABELS}-${tag}")
                }
            }
        }
        stage('GCR initialize authentication') {
            steps {
                script {
                    sh "gcloud auth activate-service-account --key-file ./jenkins-kubernetes-admin.json"
                    sh "gcloud auth configure-docker"
                }
            }
        }
        stage('Push images') {
            steps {
                script {
                    def tag = sh(returnStdout: true, script: "git describe --abbrev=0 --tags | sed 's/* //'").trim()
                    docker.withRegistry('https://gcr.io', 'gcr:staging-project') {
                        buildImage.push("${env.PROJECT_NAME}")
                        buildImage.push("${NODE_LABELS}-${tag}")
                    }
                }
            }
        }
        // stage('Deploy to GKE') {
        //     steps{
        //         sh "sed -i 's/hello:latest/hello:${env.BUILD_ID}/g' deployment.yaml"
        //         step([$class: 'KubernetesEngineBuilder', projectId: env.PROJECT_ID, clusterName: env.CLUSTER_NAME, location: env.LOCATION, manifestPattern: 'deployment.yaml', credentialsId: env.CREDENTIALS_ID, verifyDeployments: true])
        //     }
        // }
    }
}