.PHONY: clean data lint requirements sync_data_to_s3 sync_data_from_s3

#################################################################################
# GLOBALS                                                                       #
#################################################################################

PROJECT_DIR := $(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))
PROFILE = default
PYTHON_INTERPRETER = python3
PYTHON_VERSION = 3.12.0
PROJECT_NAME= "ds-infra"

# Source for a good Python Makefile: https://gist.github.com/genyrosk/2a6e893ee72fa2737a6df243f6520a6d

# Colors for echos 
ccend=$(shell tput sgr0)
ccbold=$(shell tput bold)
ccgreen=$(shell tput setaf 2)
ccred=$(shell tput setaf 1)
ccso=$(shell tput smso)
#################################################################################
# ENV CHECK                                                                     #
#################################################################################

# Check if Anaconda is present in the system
ifeq (,$(shell which conda))
HAS_CONDA=False
else
HAS_CONDA=True
endif

# Check if Pyenv is present in the system
ifeq (,$(shell which pyenv))
HAS_PYENV=False
else
HAS_PYENV=True
endif

# Check if Poetry is present in the system
ifeq (,$(shell which poetry))
HAS_POETRY=False
else
HAS_POETRY=True
endif

# Check if the current directory if a git repo
IS_GIT_REPO := $(shell git rev-parse --is-inside-work-tree 2>/dev/null)


#################################################################################
# COMMANDS (GENERAL)                                                            #
#################################################################################

## Delete all compiled Python files
clean:
	@echo "$(ccso)--> Delete all compiled Python files$(ccend)"
	find . -type f -name "*.py[co]" -delete
	find . -type d -name "__pycache__" -delete

## Test python environment is setup correctly
test_environment:
	@echo "$(ccso)--> Test the local virtual env systems available$(ccend)"
ifeq (True,$(HAS_CONDA))
	@echo ">>> Conda is $(ccgreen)available$(ccend)"
else
	@echo ">>> Conda is $(ccred)not available$(ccend)"
endif
ifeq (True,$(HAS_PYENV))
	@echo ">>> Pyenv is $(ccgreen)available$(ccend)"
else
	@echo ">>> Pyenv is $(ccred)not available$(ccend)"
endif
ifeq (True,$(HAS_POETRY))
	@echo ">>> Poetry is $(ccgreen)available$(ccend)"
else
	@echo ">>> Poetry is $(ccred)not available$(ccend)"
endif

#################################################################################
# COMMANDS (INSTALL / SETUP)                                                    #
#################################################################################

## Install Python Dependencies (Dev)
dev-install: test_environment
	@echo "$(ccso)--> Install Python Dependencies (Dev)$(ccend)"
	$(PYTHON_INTERPRETER) -m pip install -U pip setuptools wheel
	$(PYTHON_INTERPRETER) -m pip install --upgrade pip
	$(PYTHON_INTERPRETER) -m pip install -r requirements.txt

## Set up python interpreter environment (pyenv)
create_pyenv_env:
	@echo "$(ccso)--> Set up python interpreter environment (pyenv)$(ccend)"
ifeq (True,$(HAS_PYENV))
	@echo ">>> Detected pyenv, creating pyenv environment."
	pyenv virtualenv $(PYTHON_VERSION) $(PROJECT_NAME)
	@echo ">>> New pyenv created. Activate with: pyenv activate $(PROJECT_NAME)"
	pyenv local $(PROJECT_NAME) 
	@echo ">>> By default, the pyenv is activated in the local folder"
else
	@echo ">>> No virtualenv packages installed. Please install one above first"
endif

## Delete pyenv environment
delete_pyenv_env:
	@echo "$(ccso)--> Delete pyenv environment$(ccend)"
	pyenv virtualenv-delete $(PROJECT_NAME)

## Generate .env.template from .env file
generate-template:
	@echo "$(ccso)--> Generate .env.template file from .env file$(ccend)"
	@sed '/^[^#]/s/=.*/=/g' .env > .env.template
	@echo ".env.template file generated with success"

#################################################################################
# PROJECT RULES                                                                 #
#################################################################################

## Start from homepage
run:
	cmd.exe /C start http://localhost:8881

## Populate Minio S3 Bucket with a file
init-minio:
	@echo "$(ccso)--> Populate Minio S3 Bucket with a file$(ccend)"
	python minio_starter.py

## Populate DuckDB Database with some data
init-duckdb:
	@echo "$(ccso)--> Populate DuckDB Database with some data$(ccend)"
	python duckdb_starter.py

## Start all the docker containers
start-all: start-homer start-mongo start-minio start-postgres start-dbeaver start-airflow start-mlflow start-jupyter start-rstudio start-vscode start-grafana start-labelstudio
	@echo "$(ccso)--> Start all containers$(ccend)"
	docker ps

## Stop all the docker containers
stop-all: stop-homer stop-mongo stop-minio stop-postgres stop-dbeaver stop-airflow stop-mlflow stop-jupyter stop-rstudio stop-vscode stop-grafana stop-labelstudio
	@echo "$(ccso)--> Stop all containers$(ccend)"
	docker ps

start-mongo:
	docker compose -f mongodb-express-compose.yaml up -d
	docker compose -f mongo-express-compose.yaml up -d

start-minio:
	docker compose -f minio-compose.yaml up -d

start-postgres:
	docker compose -f postgres-compose.yaml up -d

start-dbeaver:
	docker compose -f cloudbeaver-compose.yaml up -d

start-airflow:
	docker compose -f airflow-compose.yaml up -d

start-mlflow:
	docker compose -f mlflow-compose.yaml up -d

start-homer:
	docker compose -f homer-compose.yaml up -d

start-jupyter:
	docker compose -f jupyter-compose.yaml up -d

start-rstudio:
	docker compose -f rstudio-compose.yaml up -d

start-vscode:
	docker compose -f vscode-compose.yaml up -d

start-grafana:
	docker compose -f grafana-compose.yaml up -d

start-labelstudio:
	docker compose -f labelstudio-compose.yaml up -d

stop-mongo:
	docker compose -f mongodb-express-compose.yaml down
	docker compose -f mongo-express-compose.yaml down

stop-minio:
	docker compose -f minio-compose.yaml down

stop-postgres:
	docker compose -f postgres-compose.yaml down

stop-dbeaver:
	docker compose -f cloudbeaver-compose.yaml down

stop-airflow:
	docker compose -f airflow-compose.yaml down

stop-mlflow:
	docker compose -f mlflow-compose.yaml down

stop-homer:
	docker compose -f homer-compose.yaml down

stop-jupyter:
	docker compose -f jupyter-compose.yaml down

stop-rstudio:
	docker compose -f rstudio-compose.yaml down

stop-vscode:
	docker compose -f vscode-compose.yaml down

stop-labelstudio:
	docker compose -f labelstudio-compose.yaml down

stop-grafana:
	docker compose -f grafana-compose.yaml down


#################################################################################
# Self Documenting Commands                                                     #
#################################################################################

## Initial setup to follow
help_setup:
	@echo ""
	@echo "$(ccso)--> Initial setup to follow$(ccend)"
	@echo "1. Start all services by running: make start-all"
	@echo "2. (optional) You can start a specific service by using: docker compose -f postgres-compose.yaml up -d"
	@echo "3. Run the Homepage of our DS Stack with: make run"
	@echo "4. Stop all services by running: make stop-all"
	@echo "5. (optional) You can stop a specific service by using: docker compose -f postgres-compose.yaml down"
	@echo ""

.DEFAULT_GOAL := help

# Inspired by <http://marmelab.com/blog/2016/02/29/auto-documented-makefile.html>
# sed script explained:
# /^##/:
# 	* save line in hold space
# 	* purge line
# 	* Loop:
# 		* append newline + line to hold space
# 		* go to next line
# 		* if line starts with doc comment, strip comment character off and loop
# 	* remove target prerequisites
# 	* append hold space (+ newline) to line
# 	* replace newline plus comments by `---`
# 	* print line
# Separate expressions are necessary because labels cannot be delimited by
# semicolon; see <http://stackoverflow.com/a/11799865/1968>
.PHONY: help
help:
	@echo ""
	@echo "$$(tput bold)Available rules:$$(tput sgr0)"
	@echo
	@sed -n -e "/^## / { \
		h; \
		s/.*//; \
		:doc" \
		-e "H; \
		n; \
		s/^## //; \
		t doc" \
		-e "s/:.*//; \
		G; \
		s/\\n## /---/; \
		s/\\n/ /g; \
		p; \
	}" ${MAKEFILE_LIST} \
	| LC_ALL='C' sort --ignore-case \
	| awk -F '---' \
		-v ncol=$$(tput cols) \
		-v indent=19 \
		-v col_on="$$(tput setaf 6)" \
		-v col_off="$$(tput sgr0)" \
	'{ \
		printf "%s%*s%s ", col_on, -indent, $$1, col_off; \
		n = split($$2, words, " "); \
		line_length = ncol - indent; \
		for (i = 1; i <= n; i++) { \
			line_length -= length(words[i]) + 1; \
			if (line_length <= 0) { \
				line_length = ncol - indent - length(words[i]) - 1; \
				printf "\n%*s ", -indent, " "; \
			} \
			printf "%s ", words[i]; \
		} \
		printf "\n"; \
	}' \
	| more $(shell test $(shell uname) = Darwin && echo '--no-init --raw-control-chars')
	@echo ""