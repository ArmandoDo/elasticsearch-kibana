#!/bin/bash

## This script builds the dockerize version of Kibana in your
## local environment. Modify the config files if it's necessary
## 
## Usage:
## ./build-kibana.sh

## Container registry
REGISTRY_NAME="development"
KIBANA_APP_NAME="kibana"
KIBANA_APP_TAG="8.6.2"

## Get the OS
OS_TYPE=$(uname)

## Build docker image
containerize_on_linux (){
    echo "Building ${KIBANA_APP_NAME} image in ${REGISTRY_NAME}/${KIBANA_APP_NAME}:${KIBANA_APP_TAG}"

    docker build --rm --no-cache --progress=plain \
        -t ${REGISTRY_NAME}/${KIBANA_APP_NAME}:${KIBANA_APP_TAG} \
        -f ./kibana/Dockerfile ./kibana
    
    echo "Docker image building has completed successfully for ${KIBANA_APP_NAME}"
}

## Main function
main(){
    echo "${OS_TYPE} detected. Starting the installation of Kibana..."
    # Verify the OS
    case "${OS_TYPE}" in
        "Darwin")
            echo "install_darwin"
            ;;
        "Linux")
            containerize_on_linux
            ;;
        *)
            echo "System isn't supported by this script: ${OS_TYPE}"
            echo "Please contact to the support team."
            exit 1
            ;;
    esac
}

main