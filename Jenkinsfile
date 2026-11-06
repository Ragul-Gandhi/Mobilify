pipeline {
    agent any


    stages {

        // ---------- dev branch: build image and push to DEV repo ----------
        stage('Dev Pipeline') {
            when { branch 'dev' }
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
                stage('Push to DEV repo') {
                    steps {
                        withCredentials([usernamePassword(credentialsId: 'dockerhub-creds',
                                                          usernameVariable: 'DH_USER',
                                                          passwordVariable: 'DH_PASS')]) {
                            sh 'echo $DH_PASS | docker login -u $DH_USER --password-stdin'
                            sh 'docker push $REPO:$TAG'
                            sh 'docker push $REPO:latest'
                        }
                    }
                }
            }
        }

        // ---------- master branch (dev merged): NO build, push to PROD repo and deploy ----------
        stage('Prod Pipeline') {
            when { branch 'main' }
            environment {
                DEV_REPO  = 'ragulgandhi/dev'
                PROD_REPO = 'ragulgandhi/prod'
                TAG       = "${BUILD_NUMBER}"
            }
            stages {
                stage('Push to PROD repo') {
                    steps {
                        withCredentials([usernamePassword(credentialsId: 'dockerhub-creds',
                                                          usernameVariable: 'DH_USER',
                                                          passwordVariable: 'DH_PASS')]) {
                            sh 'echo $DH_PASS | docker login -u $DH_USER --password-stdin'
                            // take the image already built on dev and re-label it for prod
                            sh 'docker pull $DEV_REPO:latest'
                            sh 'docker tag $DEV_REPO:latest $PROD_REPO:$TAG'
                            sh 'docker tag $DEV_REPO:latest $PROD_REPO:latest'
                            sh 'docker push $PROD_REPO:$TAG'
                            sh 'docker push $PROD_REPO:latest'
                        }
                    }
                }
                stage('Deploy Prod') {
                    steps {
                        sh './scripts/deploy.sh $PROD_REPO $TAG mob-prod 80 80'
                    }
                }
            }
        }
    }
}
