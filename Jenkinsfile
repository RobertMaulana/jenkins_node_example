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
        if (NODE_LABELS == 'master') {
            NAMESPACE = 'staging'
        } else {
            NAMESPACE = 'testing'
        }
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
                    echo NAMESPACE
                    // def tag = sh(returnStdout: true, script: "git describe --abbrev=0 --tags | sed 's/* //'").trim()
                    // buildImage = docker.build("gcr.io/${env.GCR_PROJECT_ID}/${env.PROJECT_NAME}:${NODE_LABELS}-${tag}")
                }
            }
        }
        // stage('Push images') {
        //     steps {
        //         script {
        //             def tag = sh(returnStdout: true, script: "git describe --abbrev=0 --tags | sed 's/* //'").trim()
        //             withCredentials([file(credentialsId: 'GCR', variable: 'GCR')]) {
        //                 sh("gcloud auth activate-service-account --key-file=${GCR}")
        //                 sh "gcloud auth configure-docker"
        //                 sh "docker login -u _json_key --password-stdin https://gcr.io < gcs.json"
        //                 sh "docker push gcr.io/${env.GCR_PROJECT_ID}/${env.PROJECT_NAME}:${NODE_LABELS}-${tag}"
        //             }
        //         }
        //     }
        // }
        // stage('Remove local images') {
        //     steps {
        //         script {
        //             def tag = sh(returnStdout: true, script: "git describe --abbrev=0 --tags | sed 's/* //'").trim()
        //             // remove docker images
        //             sh("docker rmi -f gcr.io/${env.GCR_PROJECT_ID}/${env.PROJECT_NAME}:${NODE_LABELS}-${tag} || :")
        //         }
        //     }
        // }
        // stage('Deploy Application on K8s') {
        //     steps {
        //         script {
        //             def tag = sh(returnStdout: true, script: "git describe --abbrev=0 --tags | sed 's/* //'").trim()
        //             withCredentials([file(credentialsId: 'GC_KEY', variable: 'GC_KEY')]) {
        //                 sh("gcloud auth activate-service-account --key-file=${GC_KEY}")
        //                 sh("gcloud container clusters get-credentials ${env.CLUSTER_NAME} --zone ${env.LOCATION} --project ${env.GCR_PROJECT_ID}")
        //                 sh("sed -e 's|TAG|${tag}|g;s|BRANCH|${NODE_LABELS}|g' deployment/deployment.yaml | kubectl apply -f -")
        //                 sh "kubectl apply -f deployment/mongo.yaml --namespace ${env.NAMESPACE}"
        //             }
        //         }
        //     }
        // }
    }
}