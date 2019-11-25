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
                    def tag = sh(returnStdout: true, script: "git describe --abbrev=0 --tags | sed 's/* //'").trim()
                    buildImage = docker.build("gcr.io/${env.GCR_PROJECT_ID}/${env.PROJECT_NAME}:${NODE_LABELS}-${tag}")
                }
            }
        }
        stage('Push images') {
            steps {
                script {
                    def tag = sh(returnStdout: true, script: "git describe --abbrev=0 --tags | sed 's/* //'").trim()
                    withCredentials([file(credentialsId: 'GCR', variable: 'GCR')]) {
                        sh("gcloud auth activate-service-account --key-file=${GCR}")
                        sh "gcloud auth configure-docker"
                        // sh "docker push ${env.PROJECT_NAME}:${tag}"
                        sh "docker push gcr.io/${env.GCR_PROJECT_ID}/${env.PROJECT_NAME}:${NODE_LABELS}-${tag}"
                    }
                }
                    // docker.withRegistry('https://gcr.io', 'gcr:staging-project') {
                    //     sh "gcloud auth activate-service-account --key-file ./gcr.json"
                    //     sh "gcloud auth configure-docker"
                    //     echo "Pushing image To GCR"
                    //     sh "docker push ${env.PROJECT_NAME}:${tag}"
                    // }
            }
        }
        // // stage("Push image") {
        // //     steps {
        // //         script {
        // //             docker.withRegistry('https://registry.hub.docker.com', 'dockerhub') {
        // //                 buildImage.push("latest")
        // //                 buildImage.push("${tag}")
        // //             }
        // //         }
        // //     }
        // // } 

        // stage('Deploy Application on K8s') {
        //     steps {
        //         withCredentials([file(credentialsId: 'GC_KEY', variable: 'GC_KEY')]) {
        //             sh("gcloud auth activate-service-account --key-file=${GC_KEY}")
        //             sh("gcloud container clusters get-credentials ${env.CLUSTER_NAME} --zone ${env.LOCATION} --project ${env.GCR_PROJECT_ID}")
        //         }
        //     }
        // }
        // stage('Deploy to GKE') {
        //     steps{
        //         sh "sed -i 's/${env.PROJECT_NAME}:latest/${env.PROJECT_NAME}:${tag}/g' deployment/deployment.yaml"
        //         // step([$class: 'KubernetesEngineBuilder', namespace: env.NAMESPACE, projectId: env.GCR_PROJECT_ID, clusterName: env.CLUSTER_NAME, location: env.LOCATION, manifestPattern: 'deployment.yaml', credentialsId: env.CREDENTIALS_ID, verifyDeployments: true])
        //         sh "kubectl apply -f deployment/deployment.yaml"
        //     }
        // }
    }
}