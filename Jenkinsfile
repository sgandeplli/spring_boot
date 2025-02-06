pipeline {
    agent any

    environment {
        DOCKER_IMAGE_NAME = 'my-app'  // Define a name for the Docker image
        DOCKER_TAG = "${BUILD_NUMBER}"  // Use the Jenkins build number as the Docker tag
        MAVEN_HOME = '/opt/apache-maven-3.9.9' // Path to your Maven installation
        PATH = "${MAVEN_HOME}/bin:${env.PATH}" // Add Maven to the PATH
        DOCKER_HUB_USERNAME = 'sgandepalli@softility.com'  // Set your Docker Hub username
        DOCKER_HUB_PASSWORD = credentials('docker-pass') // Docker Hub password from Jenkins credentials store
    }

    stages {
        stage('Checkout from GitHub') {
            steps {
                script {
                    // Check if the directory already exists
                    if (!fileExists('first-demo-project')) {
                        // If it doesn't exist, clone the repository
                        sh 'git clone https://github.com/sekhar-dev/first-demo-project.git'
                    } else {
                        // If it exists, reset the repository to make sure it's up-to-date
                        dir('first-demo-project') {
                            sh 'git reset --hard'
                            sh 'git pull origin master'
                        }
                    }
                }
            }
        }

        stage('Build Maven Project') {
            steps {
                script {
                    // Run Maven to clean and build the project (creates .jar file in target/)
                    sh 'mvn clean install'
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    // Build the Docker image using the Dockerfile
                    // The built .jar will be in the target/ directory
                    sh '''
                    docker build -t ${DOCKER_IMAGE_NAME}:${DOCKER_TAG} .
                    '''
                }
            }
        }

        stage('Login to Docker Hub') {
            steps {
                script {
                    // Log in to Docker Hub using Jenkins credentials
                    sh """
                    echo \$DOCKER_HUB_PASSWORD | docker login -u \$DOCKER_HUB_USERNAME --password-stdin
                    """
                }
            }
        }

        stage('Push Docker Image to Docker Hub') {
            steps {
                script {
                    // Tag the Docker image for Docker Hub with the build number
                    sh """
                    docker tag ${DOCKER_IMAGE_NAME}:${DOCKER_TAG} ${DOCKER_HUB_USERNAME}/${DOCKER_IMAGE_NAME}:${DOCKER_TAG}
                    """
                    // Push the image to Docker Hub
                    sh """
                    docker push ${DOCKER_HUB_USERNAME}/${DOCKER_IMAGE_NAME}:${DOCKER_TAG}
                    """
                }
            }
        }

        stage('Run Docker Container (Optional)') {
            steps {
                script {
                    // Optionally run the container to check that the app works
                    // You can comment this out if not needed
                    sh '''
                    docker run -d -p 8888:8080 ${DOCKER_IMAGE_NAME}:${DOCKER_TAG}
                    '''
                }
            }
        }
    }

    post {
        success {
            // Success actions (can be extended as needed)
            echo "Build, Docker image creation, and Docker push successful!"
        }
        failure {
            // Failure actions (can be extended as needed)
            echo "Build or Docker image creation or push failed."
        }
    }
}
