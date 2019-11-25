// Using git within checkout
pipeline {
    agent {
      label "kubectl"
    }
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
            container('kubectl'){
                withKubeConfig([credentialsId: 'staging-project',
                serverUrl: 'https://104.155.148.152',
                contextName: 'gke_crowde-apps-258709_us-central1-a_staging',
                clusterName: 'staging']){
                    echo "Hello"
                    // sh("kubectl apply -f configmap.yml")
                    // sh("kubectl apply -f secret.yml")
                    // sh("kubectl apply -f postgres.yml")
                    // sh("kubectl apply -f ${app1_name}.yml")
                    // sh("kubectl set image deployment/${app1_name} ${app1_container_name}=${app1_image_tag}")
                    // sh("kubectl apply -f ${app2_name}.yml")
                    // sh("kubectl set image deployment/${app2_name} ${app2_container_name}=${app2_image_tag}")
                }     
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