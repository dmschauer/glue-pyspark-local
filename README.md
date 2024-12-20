# Local Glue 4.0 ETL job development (Pyspark)

This repository provides an opinionated skeleton for developing AWS Glue ETL jobs locally in a Docker container.

It provides:
- A Docker image to develop `AWS Glue 4.0 ETL` jobs locally
- A sample Glue `PySpark` job
- A sample `pytest` for the Glue PySpark job
- A `pre-commit` setup using `ruff`and `mypy` including `pyproject.toml` settings
- A `GitHub Actions` CI setup
- An explanation how to use everything (i.e. this `README.md`)

# Setup

This section explains how to setup everything locally.

If you don't need an explanation about the structure of this repository, skip to `Instructions`.
It's recommended to read everything from top to bottom though.

## Prerequisites
- The Makefile assumes you're working in a Unix environment (Mac OS, Linux, WSL)
  - I only tested it on Mac OS. 
- An AWS profile in `.aws` with appropiate permissions to access S3
  - Note the **Appendix A** on AWS setup if a) you're not familiar with this, or b) you don't need AWS access
- You _don't_ need to install Python 3.10.2 although it's mentioned in `.python-version`. That's the Python version Glue 4.0 works with and thus installed in the Docker container.

## Makefile

Other than the AWS permissions, this project can be setup entirely by using the `Makefile` to access the resources in the `setup` folder (Docker and script).

For usage in root directory:
- `make init` - creates a file `setup/.env` that contains environment variables used by Docker compose
- `make build` - creates a Docker image based on `setup/glue_4_0_0_pyspark.Dockerfile`
- `make run` - uses `docker-compose.yml` to run an image based on the image created by `make build`
- `make stop` - stops the image started by `make run` 
  
For usage when inside the Docker container:
- `make venv` - creates a Python virtual environment called `.venv` and initializes it
- `make jupyter` - uses a shell script to start `Jupyter` from inside the container, accessible via `localhost:8888`

## The Dockerfile

The `setup/glue_4_0_0_pyspark.Dockerfile` is based on an image provided by the AWS Glue team.

It installs some dependencies that were needed to install system level dependencies needed for installing the `geopandas` Python package. Even if you don't need `geopandas`, this can be useful to get you started in case you need other missing dependencies.

## The docker-compose file

The `setup/docker-compose.yml` creates a single Docker container.

The command is _roughly_ equivalent to manually running
```
WORKSPACE_LOCATION=($pwd)
JUPYTER_WORKSPACE_LOCATION={$WORKSPACE_LOCATION}/jupyter_workspace
AWS_FOLDER_LOCATION=~/.aws
AWS_PROFILE=profile-user # replace with your own profile name

docker run -v $AWS_FOLDER_LOCATION:/home/glue_user/.aws -v $WORKSPACE_LOCATION:/home/glue_user/workspace/ -v $JUPYTER_WORKSPACE_LOCATION:/home/glue_user/workspace/jupyter_workspace/ -e AWS_PROFILE=$AWS_PROFILE -e DISABLE_SSL=true -e DATALAKE_FORMATS=hudi,delta,iceberg -p 4040:4040 -p 18080:18080 -p 8998:8998 -p 8888:8888 -d --name glue_pyspark_sso --entrypoint /bin/tail amazon/aws-glue-libs:glue_libs_4.0.0_image_01 -f /dev/null
```

## Instructions

- `git clone` this repository and `cd` into it
- Open your project repository in VS Code: `code .`
- run `make run` to build and start the Docker container, this will probably take a few minutes
- In VS Code:
  - If not already available, install the extension called `Remote Development`
  - Go to `Remote Explorer` in the panel on the left side
  - Hower over the container `Dev Containers`" > `Dev Containers` > `local_glue_development` > `glue_pyspark_4_0_0_container`
  - Start a Remote Development Window by clicking on the `Attach in new Window` button
  - Inside the new Window:
    - Click on `Open folder` and choose `/home/glue_user/workspace` as your working directory
    - Click on `Terminal` > `New Terminal`
    - run `make venv`
    - Now you can work within your repository as you would "locally". For example you can 
      - install required libraries
      - simply run `pytest`
      - work with Git
    - (optionally) run `make jupyter` to run a Jupyter instance from inside the container
- To exit the `Remote Development` session simply close the window
- Run `make stop` to stop the container

# Appendix A: AWS Setup

In case you're not familiar with using the AWS CLI or simply don't need to access AWS, this Appendix is for you.

## AWS setup

Follow the instructions in https://docs.aws.amazon.com/glue/latest/dg/aws-glue-programming-etl-libraries.html#develop-local-docker-image under `Configuring AWS`

## Working without any AWS setup

If you don't want to access any resources in AWS while developing locally, you can still use this project as is. All you would need to change is one line in the `src/sample.py` job that downloads a file from S3. You could replace it with a locally stored file. The same file is available in this repository in `data/persons.json`. Just take a look at the `src/sample.py`, you will find a comment that shows the required change.

## Appendix B: Useful commands

- `docker exec -it glue_pyspark_leidis /bin/sh` - start a shell session within the container
- `docker exec -it --user root glue_pyspark_leidis /bin/sh` - start a shell session within the container as root user
