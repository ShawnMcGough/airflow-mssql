# What is airflow-mssql?
A Dockerfile that extends Bitnami's docker airflow image(s) to include the bits necessary to support Microsoft SQL Server (mssql). It uses a multi-stage build to keep the final image clean. It has been generalized to work with all three airflow images (airflow, worker, scheduler).

# Why is this necessary? 
Bitnami's images do not include Microsoft drivers or pyodbc. You can read more [here](https://github.com/bitnami/charts/issues/5970) if interested.

# How to use
```bash
docker build --build-arg IMAGE=airflow -t mcgough/airflow:latest .
docker build --build-arg IMAGE=airflow-worker -t mcgough/airflow-worker:latest .
docker build --build-arg IMAGE=airflow-scheduler -t mcgough/airflow-scheduler:latest .
```