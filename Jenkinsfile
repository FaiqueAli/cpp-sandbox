pipeline {
    agent {
        // Use the Docker image for the build environment
        docker {
            image 'compile-sandbox-cal:v1' // Replace with the image name you used when building the Dockerfile
            label 'docker' // Optional: use a node with Docker installed
        }
        }
    stages {
        stage('Checkout') {
            steps {
                checkout scmGit(branches: [[name: 'main']], 
                                userRemoteConfigs: [[url: 'https://github.com/raghav-bhardwaj/python']])
            }
        }
        stage('Build') {
            steps {
                // Compile the C++ program
                sh 'make'
            }
        }
        stage('Test Run') {
            steps {
                // Run the calculator application for a basic test
                sh './calculator'
            }
        }
        stage('Clean Up') {
            steps {
                // Clean the build files
                sh 'make clean'
            }
        }
    }
}
