import boto3
import os

client = boto3.client('synthetics')


def get_canary_last_run_status():
    canary_name = os.environ['CANARY_NAME']
    response = client.describe_canaries_last_run(Names=[canary_name])
    latest_runs = response['CanariesLastRun']

    if latest_runs:
        last_run_status = latest_runs[0]['LastRun']['Status']['State']
        return last_run_status

    return None


def lambda_handler(event, context):
    last_run_status = get_canary_last_run_status()

    if last_run_status is None:
        return {
            'completed': False,
            'error': "Canary status not found"
        }
    elif last_run_status in {"PASSED", "FAILED"}:
        return {
            'completed': True,
            'error': None if last_run_status == "PASSED" else last_run_status
        }
    elif last_run_status in {"RUNNING", "CREATING", "STARTING", "UPDATING"}:
        return {
            'completed': False,
            'error': None
        }
    else:
        return {
            'completed': True,
            'error': f"Canary in an unknown state: {last_run_status}"
        }
