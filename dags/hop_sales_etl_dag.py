from airflow import DAG
from airflow.operators.bash import BashOperator
from datetime import datetime
from textwrap import dedent

PROJECT_HOME = "/opt/airflow/dags/hop_project/DOAN_NHOM12"
RUN_CONFIG_WORKFLOW = "TEST"   
RUN_CONFIG_PIPELINE = "local"  

with DAG(
    dag_id="hop_sales_etl_daily",
    start_date=datetime(2025, 8, 1),
    schedule_interval="0 7 * * *",  # chạy 7h sáng mỗi ngày
    catchup=False,
    tags=["apache-hop", "etl"],
) as dag:

    run_full_workflow = BashOperator(
        task_id="run_full_etl",
        bash_command=dedent(f"""\
set -euo pipefail
set -x

echo "== SHOW metadata folders =="
ls -la "{PROJECT_HOME}/metadata/workflow-run-configuration" || true
ls -la "{PROJECT_HOME}/metadata/pipeline-run-configuration" || true
export HOME=${{HOME:-/home/airflow}}
echo "== Prepare Hop home =="
mkdir -p "$HOME/.hop/config" "$HOME/.hop/audit"
echo "== RUN hop-run =="
/opt/hop/hop-run.sh \\
    -r "{RUN_CONFIG_WORKFLOW}" \\
    -s HOP_METADATA_FOLDER="{PROJECT_HOME}/metadata" \\
    -s HOP_DEFAULT_PIPELINE_RUN_CONFIG="{RUN_CONFIG_PIPELINE}" \\
    -s HOP_DEFAULT_WORKFLOW_RUN_CONFIG="{RUN_CONFIG_WORKFLOW}" \\
    -s DB_HOST=pg_main \\
    -s DB_PORT=5432 \\
    -s DB_NAME=olist \\
    -s DB_USER=postgres \\
    -s DB_PASS=postgres \\
    -p "PROJECT_HOME={PROJECT_HOME}" \\
    -f "{PROJECT_HOME}/Apache Hop/elt_dataset.hwf" \\
    -l Detailed \\
    -o
"""),
        env={
            "HOP_CONFIG_FOLDER": "/home/airflow/.hop/config",
            "HOP_AUDIT_FOLDER": "/home/airflow/.hop/audit",
            "HOP_PROJECT_NAME": "sales_etl",
            "HOP_PROJECT_DIRECTORY": PROJECT_HOME,
            "HOP_METADATA_FOLDER": f"{PROJECT_HOME}/metadata",
            "HOP_LOG_LEVEL": "Detailed",
        },
    )
