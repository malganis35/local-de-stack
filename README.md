# Local Data Engineering Stack

This repo was created in conjunction with a [blog post](https://kengbailey.com/a-simplified-data-stack-postgresql-duckdb-mongodb-and-minio/) @ kengbailey.com detailing my local data engineering setup. 

### How to install Docker?

[Install Docker Desktop (mac, windows, linux)](https://docs.docker.com/engine/install/)

[Install Docker commandline (linux)](https://docs.docker.com/engine/install/ubuntu/)


### How to install Docker Compose?

[Install Docker Compose](https://docs.docker.com/compose/install/)


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