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
                withKubeConfig([credentialsId: 'K8s',
                    caCertificate: '-----BEGIN PRIVATE KEY-----\nMIIEvgIBADANBgkqhkiG9w0BAQEFAASCBKgwggSkAgEAAoIBAQC18Uar1eRmdxFl\n+awVjXRsLLk6YfNdQTU9vWpX06e3fHaJrMynKX+PeszGWWHhDKzY6MXzKJjqCLzZ\n59r/u8zSp3XO8XX2WCcWf/k6VCifd1SGZyXiDmmDnLfSINCyiSad7HWAcXRTElzE\n9mUvjEoZIkK4QbLSUX8lfvfrVWLvhptcWsXpig0vjwscbxhKipg4aQvlskKm6j4E\nGdQOnxavzjQP84WigOTg7D2BbVOWqC1pLZ+0VOEHfUbUK/J85gNRTNW7pYsWSq0F\na1w27PzljRlk9DP/2r8S29dEgFP/fs45Ll131fPN1JeyhxFiQpmMB93X2Jfcy1bD\ni8PRkJ+DAgMBAAECggEAB4jYXmFbNgsUQ17Vi4byHVC00wAfbes3Yzkm4EA5n9Wd\nqxHm371ONQjm1gf5j7JQriLln648tuRpvbRmU1TZpJeev1Ush2kbJUljbtDxZbkx\nXOeEoBnssLCaxC7rtZkMalnSe+E26gHGqblyc0eiAexzSuIdn6wUUd8yMSK2GCku\n13ZTdqxZIwASEhkqJk6QTdz2Ohnz2oaoJlkmRp8H8fN9GynaFfe/Ca4Ywx+KWf72\nEBWdZor/XagFPf5r3ZfsNDmB/I2JaUJ/sxK+ufnOZE09viyKlnIMIeZ/z7sKDzzL\nRUy1wRmYdCn3thdsY28GXjpZDNkw36pGz5WAV2K6gQKBgQD3RPynTaNgd1WdZwXH\nziDObl8l1yL/mCDaXpzVWwpgq8OQTVeEbIkypLQwDSFSosTcMGIy3E9KE9C93Gay\nTfn0EmsXVWnbh4HJDVsMKIazVPtHfspPCKbnJtcD1qZk/gBzCYBIYoGFGvCnL4go\nwuz9cQw11hv/FI+T4d8/D48HIQKBgQC8XdAqlqL3fK9sX0UR50+yWy5MxYjaH1cA\nssKMZnzjMxG1bpGzIEnaeNuSVqZq1HKv04TrCWk0ypsYJydc216XD463mihCEJXd\nN8k1xAVJLV+iagES50u/ZvXCzlxPwga0CEDxQemyotC1dU5JIY8qy97cVsu3EwUB\n534eDDvmIwKBgExLF92TIe64w0zOpcTxf8PR4D+vspfEW5alDKTz8y7CsJOMmY09\nY9OhaAtPcdGqcS0zLIle2oQTuxtprrIjRxUcvbg0XXYjyFK9cTM+KdmZRfLYVxmt\npLm7jSodB7gvevoDm3Y6FpZ4KnqbOtrA0hic0dSmnHrG4EoTrisp5MqhAoGBAKuZ\nLwVNO2MIRGsOk0aPGaxaomAv588Fk+W/87mhuA3mPTCybKrpND6BsU2sAGj75wrE\nP6c6aIw+MnIbYSGXeqFU++fI2PnuUAg6ROPlEgeq/R9hQF8vNHNGYYa5JaFHGYIy\nrq7aJAKnjkhweAPpPZp4JStHKsg53Gryr5LCBGNPAoGBAKp6gFFSs/ytx2X7FkG9\nJRD1XE0T6SBLNX5hlNDvf3qV0RjpfLbC2YtfmGeZHL4QqQyJN0xgsapLpf7Af0/u\n5457AuaoGESk+qpp6aSoYkAKbLrJ9SxQa4C/Sreqi5xNiuKdaY+NfjXhm64XkwI0\nVH1AVny3v1TRTCRzTayMTdcS\n-----END PRIVATE KEY-----\n',
                    serverUrl: 'https://104.155.148.152',
                    contextName: 'gke_crowde-apps-258709_us-central1-a_staging',
                    clusterName: 'staging',
                    namespace: 'staging'
                    ])
                {
                    sh 'kubectl get pods'
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