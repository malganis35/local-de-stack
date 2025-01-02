# Local Data Science & Engineering Stack

This repo was created in conjunction with a [blog post](https://kengbailey.com/a-simplified-data-stack-postgresql-duckdb-mongodb-and-minio/) @ kengbailey.com detailing my local data engineering setup. 

This repo is intended to create a ready production data and machine learning stack. This stack is composed of:

- **Minio**: S3 Storage
- **PostgreSQL**: Structured SQL Database
- **MongoDB**: Semi-structured Data
- **DBeaver/CloudBeaver**: UI to read Database
- **Airflow**: orchestrator
- **MLFlow**: experiment tracking
- **Homer**: Homepage of the Stack
- **JupyterHub**: Exploration in jupyter notebook
- **VSCode Server**: Online IDE
- **RStudio Server**: Online IDE
- **LabelStudio**: Asset to labels data

### How to install Docker?

[Install Docker Desktop (mac, windows, linux)](https://docs.docker.com/engine/install/)

[Install Docker commandline (linux)](https://docs.docker.com/engine/install/ubuntu/)


### How to install Docker Compose?

[Install Docker Compose](https://docs.docker.com/compose/install/)

### Commands to start and stop services?

1. Setup all containers:
```
make start-all
```

2. Open the Homepage
```
make run
```

3. Close all services
```
make stop-all
```


### Commands to start and stop services?

Run and view logs
```
docker compose -f postgres-compose.yaml up 
```

Run in detached mode
```
docker compose -f postgres-compose.yaml up -d
```

Stop
```
docker compose -f postgres-compose.yaml down
```