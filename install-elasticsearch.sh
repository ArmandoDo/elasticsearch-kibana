#!/bin/bash

## This script builds the dockerize version of Elasticsearch in your
## local environment. Modify the config files if it's necessary
## 

## Container registry
export REGISTRY_NAME="development"
export APP_NAME="elasticsearch"
export APP_TAG="8.6.2"

## Volume info
export VOLUME_NAME="elasticsearch_data"

## Get the OS
OS_TYPE=$(uname)

## Install docker image on linux
install_on_linux() {
    source .env
    create_volume
    stop_container
    docker compose --file docker-compose.yml up --detach ${APP_NAME}

}

### Stop docker container
stop_container() {
    docker compose --file docker-compose.yml stop ${APP_NAME}
    docker compose --file docker-compose.yml rm --force ${APP_NAME}
}

## Main function
main() {
    echo "${OS_TYPE} detected. Starting the installation..."
    # Verify the OS
    case "${OS_TYPE}" in
        "Darwin")
            echo "install_darwin"
            ;;
        "Linux")
            install_on_linux
            ;;
        *)
            echo "System isn't supported by this script: ${OS_TYPE}"
            echo "Please contact to the support team."
            exit 1
            ;;
    esac

    echo "${APP_NAME} docker image deployed on host..."
}

main