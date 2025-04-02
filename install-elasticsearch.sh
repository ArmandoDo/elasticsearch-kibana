#!/bin/bash

## This script install the dockerize version of Elasticsearch in your
## local environment. Run the build script before start the installation
##
## Usage:
## ./install-elasticsearch.sh
# set -ex

## Container registry
export REGISTRY_NAME="development"
# Elasticsearch
export ELASTICSEARCH_APP_NAME="elasticsearch"
export ELASTICSEARCH_APP_TAG="8.6.2"
# Kibana
export KIBANA_APP_NAME="kibana"
export KIBANA_APP_TAG="8.6.2"

## Volume info
export ELASTICSEARCH_DATA_VOLUME_NAME="elasticsearch_data"

## Get the OS
OS_TYPE=$(uname)

## Install docker image of Elasticsearch
install_elasticsearch() {
    set_up_env_variable_file
    stop_container
    ${DOCKER_COMPOSE_COMMAND} --file ${DOCKER_COMPOSE_FILE} up --detach ${ELASTICSEARCH_APP_NAME}

}

# Set up the docker compose command available on the server
set_up_docker_compose_command() {
    if command -v docker-compose &> /dev/null; then
        export DOCKER_COMPOSE_COMMAND="docker-compose"
    elif command -v docker compose &> /dev/null; then
        export DOCKER_COMPOSE_COMMAND="docker compose"
    else
        echo "Docker Compose is not installed or started in your system.
        Please install the service."
        echo "Exiting..."

        exit 1
    fi
}

# Set up the environment variable file .env
set_up_env_variable_file() {
    if ! source .env; then
        echo "Missing .env file with the environment variables. Please create the .env file"
        exit 1
    fi
}

## Stop docker container
stop_container() {
    ${DOCKER_COMPOSE_COMMAND} --file ${DOCKER_COMPOSE_FILE} stop ${ELASTICSEARCH_APP_NAME}
    ${DOCKER_COMPOSE_COMMAND} --file ${DOCKER_COMPOSE_FILE} rm --force ${ELASTICSEARCH_APP_NAME}
}

# Verify if the Docker engine is installed on the system
verify_docker_engine() {
    # Verify if service is installed
    if ! command -v docker &> /dev/null; then
        echo "Docker Engine is not installed in your system. Please install the service..."
        echo "Exiting..."
        exit 1
    fi

    # Verify if service is running
    if ! docker info &> /dev/null; then
        echo "Docker engine is installed, but not started. Please launch the service..."
        echo "Exiting..."
        exit 1
    fi
}

## Main function
main() {
    echo "${OS_TYPE} detected. Starting the installation..."
    # Verify the OS
    case "${OS_TYPE}" in
        "Darwin")
            export DOCKER_COMPOSE_FILE="docker-compose.darwin.yml"
            verify_docker_engine
            set_up_docker_compose_command
            install_elasticsearch
            ;;
        "Linux")
            export DOCKER_COMPOSE_FILE="docker-compose.ubuntu.yml"
            verify_docker_engine
            set_up_docker_compose_command
            install_elasticsearch
            ;;
        *)
            echo "System isn't supported by this script: ${OS_TYPE}"
            echo "Please contact to the support team."
            exit 1
            ;;
    esac

    echo "${ELASTICSEARCH_APP_NAME} docker image deployed on host..."
}

main