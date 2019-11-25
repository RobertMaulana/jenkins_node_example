pipeline {
    agent any
    environment {
        PROJECT_NAME = 'jenkins_node_example'
        DISABLE_AUTH = 'true'
        DB_ENGINE    = 'sqlite'
        GCR_PROJECT_ID   = 'crowde-apps-258709'
        LOCATION = 'us-central1-a'
        CREDENTIALS_ID = 'gke'
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
                    buildImage = docker.build("gcr.io/${env.GCR_PROJECT_ID}/${env.PROJECT_NAME}:${tag}")
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
                        sh "docker login -u _json_key --password-stdin https://gcr.io < gcs.json"
                        sh "docker push gcr.io/${env.GCR_PROJECT_ID}/${env.PROJECT_NAME}:${tag}"
                    }
                }
            }
        }
        stage('Remove local images') {
            steps {
                script {
                    def tag = sh(returnStdout: true, script: "git describe --abbrev=0 --tags | sed 's/* //'").trim()
                    // remove docker images
                    sh("docker rmi -f gcr.io/${env.GCR_PROJECT_ID}/${env.PROJECT_NAME}:${tag} || :")
                }
            }
        }
        stage('Deploy Application on K8s') {
            steps {
                script {
                    def tag = sh(returnStdout: true, script: "git describe --abbrev=0 --tags | sed 's/* //'").trim()
                    String a = GIT_BRANCH;
                    String[] str;
                    str = a.split('/');
                    String branch;
                    branch = str[2].split('-')[0]
                    if (branch == 'staging') {
                        CLUSTER_NAME = 'staging'
                        NAMESPACE = 'staging'
                    } else {
                        CLUSTER_NAME = 'staging'
                        NAMESPACE = 'testing'
                    }
                    withCredentials([file(credentialsId: 'GC_KEY', variable: 'GC_KEY')]) {
                        sh("gcloud auth activate-service-account --key-file=${GC_KEY}")
                        sh("gcloud container clusters get-credentials ${CLUSTER_NAME} --zone ${env.LOCATION} --project ${env.GCR_PROJECT_ID}")
                        sh("kubectl create ns ${NAMESPACE}")
                        sh("sed -e 's|TAG|${tag}|g;s|NAMESPACE|${NAMESPACE}|g' deployment/deployment.yaml | kubectl apply -f -")
                        sh("sed -e 'ss|NAMESPACE|${NAMESPACE}|g' deployment/mongo.yaml | kubectl apply -f -")
                    }
                }
            }
        }
    }
}