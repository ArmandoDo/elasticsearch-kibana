#!/bin/bash

## This script installs the dockerize version of Kibana in your
## local environment. Elasticsearch is a requirement for the Kibana
## installation.
##
## Usage:
## ./install-kibana.sh

## Container registry
export REGISTRY_NAME="development"
# Elasticsearch
export ELASTICSEARCH_APP_NAME="elasticsearch"
export ELASTICSEARCH_APP_TAG="8.6.2"
# Kibana
export KIBANA_APP_NAME="kibana"
export KIBANA_APP_TAG="8.6.2"

## Get the OS
OS_TYPE=$(uname)

## Install docker image of Kibana
install_kibana() {
    set_up_env_variable_file
    stop_container
    ${DOCKER_COMPOSE_COMMAND} --file ${DOCKER_COMPOSE_FILE} up --detach ${KIBANA_APP_NAME}
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
    ${DOCKER_COMPOSE_COMMAND} --file ${DOCKER_COMPOSE_FILE} stop ${KIBANA_APP_NAME}
    ${DOCKER_COMPOSE_COMMAND} --file ${DOCKER_COMPOSE_FILE} rm --force ${KIBANA_APP_NAME}
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
            install_kibana
            ;;
        "Linux")
            install_on_linux
            ;;
        *)
            export DOCKER_COMPOSE_FILE="docker-compose.ubuntu.yml"
            verify_docker_engine
            set_up_docker_compose_command
            install_kibana
            ;;
    esac

    echo "${KIBANA_APP_NAME} docker image deployed on host..."
}

main