# Makefile

# Load environment variables dynamically
define load-env
$(eval $(shell bash setup/set-env.sh))
endef

# Call load-env at the start
$(eval $(call load-env))

# Initialize environment
init:
	@chmod +x setup/set-env.sh
	@echo "Environment initialized:"
	@cat setup/.env

# Build the Docker image
build: init
	docker-compose -f setup/docker-compose.yml build

# Run the container with appropriate environment and network
run: build
	docker-compose -f setup/docker-compose.yml up -d

# (for usage within container)
# Setup virtual environment in container
venv:
	python3.10 -m venv /home/glue_user/.venv && \
	source /home/glue_user/.venv/bin/activate && \
	pip install --upgrade pip

# (for usage within container)
# Start Jupyter
jupyter:
	/home/glue_user/jupyter/jupyter_start.sh

# Stop the container
stop:
	docker-compose -f setup/docker-compose.yml down
