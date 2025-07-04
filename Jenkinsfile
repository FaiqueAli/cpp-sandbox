
// def ensureDirectoryExists(String dir)
// {
//     sh "mkdir -p \"${dir}\""
// }
// def syncDirectories(String source, String target)
// {
//     ensureDirectoryExists(target)
//     sh "rsync --delete -auq --no-o --no-g --no-p --omit-dir-times --modify-window=1 \"${source}\" \"${target}\""
// }
// def prepareCache(String baseDir, String branchDir, String subDir = "", boolean forceSync = false)
// {
//     def getFullDir = { String dir -> subDir == "" ? dir : "${dir}/${subDir}" }
 
//     final fullBaseDir = getFullDir(baseDir)
//     final fullBranchDir = getFullDir(branchDir)
 
//     if(fileExists(fullBranchDir) && !forceSync)
//     {
//         echo "Reusing branch cache"
//     }
//     else
//     {
//         ensureDirectoryExists(fullBranchDir)
 
//         echo "Checking ${fullBaseDir} for existing cache"
 
//         final fullBaseDirExists = sh(script: "test -d ${fullBaseDir}", returnStatus: true) == 0
 
//         if(fullBaseDirExists)
//         {
//             echo "Updating branch cache with global one"
//             syncDirectories(fullBaseDir, fullBranchDir)
//         }
//         else
//         {
//             echo "No global cache available - continuing without"
//         }
//     }
// }

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
    parameters {
            gitParameter branchFilter: 'origin/(.*)', defaultValue: 'main', name: 'BRANCH', type: 'PT_BRANCH'
        }    
     environment {
        DOCKER_HOST = 'tcp://host.docker.internal:2375'
        CHANGED_FOLDERS = ""
         MY_USER = credentials('test') // Use this only if using secret text
    }
    
      
    stages {

        stage('Login') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'test', 
                                                  usernameVariable: 'USERNAME', 
                                                  passwordVariable: 'PASSWORD')]) {
                    sh 'echo "Logging in as $USERNAME"'
                    sh 'echo "Logging in as $PASSWORD"'
                }
            }
        
        stage('Checkout') {
            steps {
                checkout scmGit(branches: [[name: 'main']], 
                                userRemoteConfigs: [[url: 'https://github.com/FaiqueAli/cpp-sandbox.git']])
            }
        }
        stage('Build') {
            // when {
            //     branch 'main' // Only for master branch
            // }
            
            steps {

                //start
                script {
                        sh 'git rev-parse origin/main > .cache'
                         // Determine the type of branch
                        def isMainBranch = (env.BRANCH_NAME == 'main')
                        def isReleaseBranch = (env.BRANCH_NAME?.startsWith('release/'))
                        // Cache save logic
                        def cacheSave = isMainBranch || isReleaseBranch // Save cache for main or release branches
                        
                        // Clear cache for release branches
                        if (isReleaseBranch) {
                            echo "On a release branch. Clearing existing cache."
                            sh "rm -rf $WORKSPACE/**" // Ensure all existing cache is cleared
                        }
                        // Job Cacher plugin call
                        cache(
                            skipSave: !cacheSave, // Skip saving the cache for non-main branches
                            caches: [
                                arbitraryFileCache(
                                    path: "$WORKSPACE",
                                    // includes: "**/libarithmetic_ops.a",
                                    includes: "compile.sh",
                                    cacheValidityDecidingFile: isMainBranch || isReleaseBranch ? '.cache' : null // Use '.cache' only for main
                        )],
                            defaultBranch: "main"
                        )
                        {
                            //----start
                            if (isMainBranch || isReleaseBranch) {
                                // Compile the C++ program
                                sh 'chmod -R a+rwx $WORKSPACE/'
                                // sh './folderNames.sh'
                                sh './compile.sh'

                            } else if (env.CHANGE_ID) {
                                echo "This is a pull request to the main branch. Pull Request ID: ${env.CHANGE_ID}"
                                // Add actions specific to pull requests targeting main
                            } else {
                                echo "This is not the main branch or a pull request."
                                    // sh 'chmod +x folderNames.sh'
                                    // sh './folderNames.sh'
                                    sh 'chmod +x compile.sh'
                                    sh './compile.sh'

                            }
                            //----end
                        }
                    }
                //end
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
    post {
            always {
                archiveArtifacts artifacts: '**/*.a', fingerprint: true
                }
        }
    
    }