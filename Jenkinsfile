pipeline {
    agent any

    environment {
        // Nom de l'image Docker
        DOCKER_IMAGE = 'projetdebops'
        DOCKER_REGISTRY = 'ton_utilisateur_docker'  // Remplace par ton nom d'utilisateur Docker Hub
        DOCKER_TAG = 'latest'
    }

    stages {
        stage('Checkout') {
            steps {
                // Récupérer le code depuis GitHub
                checkout scm
            }
        }

        stage('Build') {
            steps {
                // Construire l'application Maven
                sh 'mvn clean install'
            }
        }

        stage('Unit Tests') {
            steps {
                // Lancer les tests unitaires avec Maven
                sh 'mvn test'
            }
        }

        stage('Docker Build') {
            steps {
                // Construire l'image Docker
                sh 'docker build -t ${DOCKER_REGISTRY}/${DOCKER_IMAGE}:${DOCKER_TAG} .'
            }
        }

        stage('Docker Push') {
            steps {
                // Pousser l'image Docker vers Docker Hub
                withDockerRegistry([credentialsId: 'docker-hub-credentials', url: 'https://index.docker.io/v1/']) {
                    sh 'docker push ${DOCKER_REGISTRY}/${DOCKER_IMAGE}:${DOCKER_TAG}'
                }
            }
        }

        stage('Deploy') {
            steps {
                // Déployer l'application sur un serveur distant
                sshPublisher(publishers: [
                    sshPublisherDesc(configName: 'remote-server',
                                     transfers: [sshTransfer(sourceFiles: 'target/projetdebops.jar', remoteDirectory: '/var/app')],
                                     usePromotionTimestamp: false, verbose: true)
                ])
            }
        }
    }
}

