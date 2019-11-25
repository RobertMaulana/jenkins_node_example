// Using git within checkout
pipeline {
    agent any
    environment {
        PROJECT_NAME = 'jenkins_node_example'
        DISABLE_AUTH = 'true'
        DB_ENGINE    = 'sqlite'
        GCR_PROJECT_ID   = 'crowde-apps-258709'
        CLUSTER_NAME = 'staging'
        LOCATION = 'us-central1-a'
        CREDENTIALS_ID = 'gke'
        NAMESPACE = 'staging'
    }
    stages {
        stage("Checkout code") {
            steps {
                checkout scm
            }
        }
        stage('Build image') {
            steps {
                script {
                    tag = sh(returnStdout: true, script: "git describe --abbrev=0 --tags | sed 's/* //'").trim()
                    buildImage = docker.build("robertmaulana/${env.PROJECT_NAME}:${tag}")
                }
            }
        }
        stage("Push image") {
            steps {
                script {
                    docker.withRegistry('https://registry.hub.docker.com', 'dockerhub') {
                        buildImage.push("latest")
                        buildImage.push("${tag}")
                    }
                }
            }
        } 

        stage('Deploy Application on K8s') {
            steps {
                withCredentials([file(credentialsId: 'K8s', variable: 'K8S')]) {
                    sh("gcloud auth activate-service-account --key-file=${K8S}")
                    // sh("gcloud container clusters get-credentials prod --zone northamerica-northeast1-a --project ${project}")
                }
                // withCredentials([
                //     [
                //         $class: 'StringBinding',
                //         credentialsId: "K8s",
                //         variable: 'GOOGLE_APPLICATION_CREDENTIALS'
                //     ]
                // ]) {
                //     sh 'echo "${GOOGLE_APPLICATION_CREDENTIALS}"'
                // }
            }
        }
        // stage('Deploy to GKE') {
        //     steps{
        //         sh "sed -i 's/${env.PROJECT_NAME}:latest/${env.PROJECT_NAME}:${tag}/g' deployment/deployment.yaml"
        //         // step([$class: 'KubernetesEngineBuilder', namespace: env.NAMESPACE, projectId: env.GCR_PROJECT_ID, clusterName: env.CLUSTER_NAME, location: env.LOCATION, manifestPattern: 'deployment.yaml', credentialsId: env.CREDENTIALS_ID, verifyDeployments: true])
        //         sh "kubectl apply -f deployment/deployment.yaml"
        //     }
        // }

        // TODO: push image to GCR
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
    }
}