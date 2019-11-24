// Using git within checkout
pipeline {
    agent any
    parameters {
        gitParameter name: 'TAG',
                     type: 'PT_TAG',
                     defaultValue: 'master'
    }
    environment {
        PROJECT_NAME = 'jenkins_node_example'
    }
    stages {
        stage('Example') {
            steps {
                checkout([$class: 'GitSCM',
                          branches: [[name: "${params.TAG}"]],
                          doGenerateSubmoduleConfigurations: false,
                          extensions: [],
                          gitTool: 'Default',
                          submoduleCfg: [],
                          userRemoteConfigs: [[url: 'https://github.com/RobertMaulana/jenkins_node_example.git']]
                        ])
            }
        }
        stage('Build image') {
            steps {
                script {
                    myapp = docker.build("robertmaulana/${env.PROJECT_NAME}:${git describe --abbrev=0 --tags | sed 's/* //'}")
                }
            }
        }
    }
}