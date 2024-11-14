pipeline {
    agent any
    stages {
        stage('Clone Repository') {
            steps {
                // Clone your repository containing the calculator code
                git 'https://your-repo-url.git'
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
