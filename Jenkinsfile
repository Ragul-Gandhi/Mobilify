pipeline {
    agent any

    triggers {
        githubPush()
    }

    stages {

        stage('Checkout') {
            steps {
                checkout scm
                script {
                    env.GIT_BRANCH_NAME = sh(
                        script: "git rev-parse --abbrev-ref HEAD",
                        returnStdout: true
                    ).trim()

                    echo "Current Branch: ${env.GIT_BRANCH_NAME}"
                }
            }
        }

        stage('Dev Pipeline') {
            when {
                expression { env.GIT_BRANCH_NAME == 'dev' }
            }

            environment {
                REPO = 'ragulgandhi/dev'
                TAG  = "${BUILD_NUMBER}"
            }

            stages {

                stage('Build Image') {
                    steps {
                        sh './scripts/build.sh $REPO $TAG'
                    }
                }

                stage('Push to DEV Repo') {
                    steps {
                        withCredentials([
                            usernamePassword(
                                credentialsId: 'dockerhub-creds',
                                usernameVariable: 'DH_USER',
                                passwordVariable: 'DH_PASS'
                            )
                        ]) {
                            sh '''
                                echo $DH_PASS | docker login -u $DH_USER --password-stdin
                                docker push $REPO:$TAG
                                docker push $REPO:latest
                            '''
                        }
                    }
                }
            }
        }

        stage('Prod Pipeline') {
            when {
                expression { env.GIT_BRANCH_NAME == 'main' }
            }

            environment {
                DEV_REPO  = 'ragulgandhi/dev'
                PROD_REPO = 'ragulgandhi/prod'
                TAG       = "${BUILD_NUMBER}"
            }

            stages {

                stage('Push to PROD Repo') {
                    steps {
                        withCredentials([
                            usernamePassword(
                                credentialsId: 'dockerhub-creds',
                                usernameVariable: 'DH_USER',
                                passwordVariable: 'DH_PASS'
                            )
                        ]) {
                            sh '''
                                echo $DH_PASS | docker login -u $DH_USER --password-stdin

                                docker pull $DEV_REPO:latest

                                docker tag $DEV_REPO:latest $PROD_REPO:$TAG
                                docker tag $DEV_REPO:latest $PROD_REPO:latest

                                docker push $PROD_REPO:$TAG
                                docker push $PROD_REPO:latest
                            '''
                        }
                    }
                }

                stage('Deploy Prod') {
                    steps {
                        sh './scripts/deploy.sh $PROD_REPO $TAG mob-con 8081 80'
                    }
                }
            }
        }
    }

    post {
        always {
            echo "Pipeline completed"
        }
    }
}
