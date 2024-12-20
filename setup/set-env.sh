#!/bin/bash

# Output each variable on its own line
{
    if [ -d ~/.aws ]; then
        printf "AWS_FOLDER_LOCATION=%s\n" "$HOME/.aws"
    else
        echo "WARNING: ~/.aws directory not found. Creating it..." >&2
        mkdir -p ~/.aws
        printf "AWS_FOLDER_LOCATION=%s\n" "$HOME/.aws"
    fi

    printf "WORKSPACE_LOCATION=%s\n" "$(pwd)"

    JUPYTER_DIR="$(pwd)/jupyter_workspace"
    if [ ! -d "$JUPYTER_DIR" ]; then
        echo "Creating Jupyter workspace directory..." >&2
        mkdir -p "$JUPYTER_DIR"
    fi
    printf "JUPYTER_WORKSPACE_LOCATION=%s\n" "$JUPYTER_DIR"

    printf "AWS_PROFILE=%s\n" "profile-user"
    printf "DOCKER_IMAGE=%s\n" "glue_pyspark_4_0_0"
    printf "DOCKER_CONTAINER=%s\n" "glue_pyspark_4_0_0_container"
    printf "COMPOSE_PROJECT_NAME=%s\n" "local_glue_development"


} > setup/.env