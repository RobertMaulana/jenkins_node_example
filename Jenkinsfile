// Using git within checkout
pipeline {
    agent any
    environment {
        PROJECT_NAME = 'jenkins_node_example'
        DISABLE_AUTH = 'true'
        DB_ENGINE    = 'sqlite'
        GCR_PROJECT_ID   = 'crowde-apps-258709'
    }
    stages {
        stage('Build image') {
            steps {
                script {
                    def tag = sh(returnStdout: true, script: "git describe --abbrev=0 --tags | sed 's/* //'").trim()
                    buildImage = docker.build("${env.PROJECT_NAME}:${tag}")
                }
            }
        }
        // stage('GCR initialize authentication') {
        //     steps {
        //         script {
        //             sh "gcloud auth activate-service-account --key-file ./jenkins-kubernetes-admin.json"
        //             sh "gcloud auth configure-docker"
        //         }
        //     }
        // }
        stage('Push images') {
            steps {
                script {
                    def tag = sh(returnStdout: true, script: "git describe --abbrev=0 --tags | sed 's/* //'").trim()
                    docker.withRegistry('https://gcr.io', 'gcr:staging-project') {
                        sh "gcloud auth activate-service-account --key-file ./jenkins-kubernetes-admin.json"
                        sh "gcloud auth configure-docker"
                        echo "Pushing image To GCR"
                        sh "docker push gcr.io/${env.GCR_PROJECT_ID}/${env.PROJECT_NAME}:${tag}"
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