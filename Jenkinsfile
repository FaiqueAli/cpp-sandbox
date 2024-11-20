pipeline {
    // agent any
    agent {
        // Use the Docker image for the build environment
        docker {
            // label 'agent-lable'
            image 'compile-sandbox-cal'  // Use the Docker image with the Docker CLI
            label  'docker-agent'
            args '-e DOCKER_HOST=tcp://host.docker.internal:2375'
            args '--privileged -v /var/run/docker.sock:/var/run/docker.sock'
            // resenode true
        }
        }
     environment {
        DOCKER_HOST = 'tcp://host.docker.internal:2375'
    }
    stages {
        //  stage('Verify Docker') {
        //     steps {
        //         sh 'docker --version'
        //     }
        // }
        stage('Checkout') {
            steps {
                checkout scmGit(branches: [[name: 'main']], 
                                userRemoteConfigs: [[url: 'https://github.com/FaiqueAli/cpp-sandbox.git']])
            }
        }
        stage('Build') {
            steps {
                // Compile the C++ program
                sh './compile.sh'
            }
        }
        // stage('Test Run') {
        //     steps {
        //         // Run the calculator application for a basic test
        //         sh './calculator'
        //     }
        // }
        // stage('Clean Up') {
        //     steps {
        //         // Clean the build files
        //         sh 'make clean'
        //     }
        // }
        
        }
    post {
            always {
                archiveArtifacts artifacts: '**/*.a', fingerprint: true
                }
        }
    
    }

