// Using git within checkout
pipeline {
    agent any
    environment {
        PROJECT_NAME = 'jenkins_node_example'
        DISABLE_AUTH = 'true'
        DB_ENGINE    = 'sqlite'
        // GCR_PROJECT_ID   = 'crowde-apps-258709'
    }
    stages {
        stage('Build image') {
            steps {
                script {
                    def tag = sh(returnStdout: true, script: "git describe --abbrev=0 --tags | sed 's/* //'").trim()
                    buildImage = docker.build("robertmaulana/${env.PROJECT_NAME}:${tag}")
                }
            }
        }
        stage("Push image") {
            steps {
                script {
                    def tag = sh(returnStdout: true, script: "git describe --abbrev=0 --tags | sed 's/* //'").trim()
                    docker.withRegistry('https://registry.hub.docker.com', 'dockerhub') {
                        buildImage.push("latest")
                        buildImage.push("${tag}")
                    }
                }
            }
        } 
        // stage('Push images') {
        //     steps {
        //         script {
        //             def tag = sh(returnStdout: true, script: "git describe --abbrev=0 --tags | sed 's/* //'").trim()
        //             docker.withRegistry('https://gcr.io', 'gcr:staging-project') {
        //                 sh "gcloud auth activate-service-account --key-file ./gcr.json"
        //                 sh "gcloud auth configure-docker"
        //                 echo "Pushing image To GCR"
        //                 sh "docker push ${env.PROJECT_NAME}:${tag}"
        //             }
        //         }
        //     }
        // }
        // stage('Deploy to GKE') {
        //     steps{
        //         sh "sed -i 's/hello:latest/hello:${env.BUILD_ID}/g' deployment.yaml"
        //         step([$class: 'KubernetesEngineBuilder', projectId: env.PROJECT_ID, clusterName: env.CLUSTER_NAME, location: env.LOCATION, manifestPattern: 'deployment.yaml', credentialsId: env.CREDENTIALS_ID, verifyDeployments: true])
        //     }
        // }
    }
}