# this is not production code. just useful for testing connectivity.
from airflow.providers.odbc.hooks.odbc import OdbcHook
from airflow import DAG
from airflow.operators.python import PythonOperator, PythonVirtualenvOperator
from airflow.utils.dates import days_ago

dag = DAG(
    dag_id="mssql_example",
    default_args={},
    schedule_interval=None,
    start_date=days_ago(2),
    tags=["example"],
)


def sample_select():
    odbc_hook = OdbcHook() 
    # above will use 'odbc_default' connection
    # which you must setup in Admin->Connections
    # http://airflow.apache.org/docs/apache-airflow-providers-odbc/stable/connections/odbc.html#configuring-the-connection
    
    cnxn = odbc_hook.get_conn()

    cursor = cnxn.cursor()
    cursor.execute("SELECT @@SERVERNAME, @@VERSION;")
    row = cursor.fetchone()
    while row:
        print("Server Name:" + row[0])
        print("Server Version:" + row[1])
        row = cursor.fetchone()


PythonOperator(
    task_id="sample_select",
    python_callable=sample_select,
    dag=dag,
)
