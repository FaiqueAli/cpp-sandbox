
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
    }
    
      
    stages {

        stage('Checkout') {
            steps {
                checkout scmGit(branches: [[name: 'feature/cache']], 
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
                    if (env.BRANCH_NAME == 'main') {
                        // echo "Building the main branch directly."
                        // sh 'git rev-parse HEAD > .cache'

                        //working with cache
                        cache(caches: [
                            arbitraryFileCache(
                                path: "$WORKSPACE",
                                includes: "**/*.a",
                                cacheValidityDecidingFile: ".cache"
                            )                       
                        ],
                            defaultBranch: "main"
                        )
                        {
                        // Compile the C++ program
                            sh 'chmod -R a+rwx $WORKSPACE/'
                            sh 'pwd'
                            sh './compile.sh'
                        }



                    } 
                    else if (env.CHANGE_ID) {
                        echo "This is a pull request to the main branch. Pull Request ID: ${env.CHANGE_ID}"
                        // Add actions specific to pull requests targeting main
                    } 
                    else 
                    {
                        echo "This is not the main branch or a pull request."
                        sh 'chmod +x folderNames.sh'
                         sh './folderNames.sh'

                        // Add actions for other branches
                    }
                }

                
            }
        }
        
        }
    post {
            always {
                archiveArtifacts artifacts: '**/*.a', fingerprint: true
                }
        }
    
    }

