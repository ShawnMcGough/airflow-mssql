# What is airflow-mssql?
A Dockerfile that extends Bitnami's docker airflow image(s) to include the bits necessary to support Microsoft SQL Server (mssql). It uses a multi-stage build to keep the final image clean. It has been generalized to work with all three airflow images (airflow, worker, scheduler).

# Why is this necessary? 
Bitnami's images do not include Microsoft drivers or pyodbc. You can read more at my [blog](https://www.shawnmcgough.com/airflow-connect-to-sql-server-mssql) if interested.

# How to use
```bash
docker build --build-arg IMAGE=airflow -t mcgough/airflow:latest .
docker build --build-arg IMAGE=airflow-worker -t mcgough/airflow-worker:latest .
docker build --build-arg IMAGE=airflow-scheduler -t mcgough/airflow-scheduler:latest .
```

# Sample DAG
I could not find much in the way of a working example DAG to test mssql so I also created this quick [example DAG](https://github.com/ShawnMcGough/airflow-mssql/blob/master/mssql_example_dag.py) to test connectivity. 
