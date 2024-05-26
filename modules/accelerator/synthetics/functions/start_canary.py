import boto3
import os

client = boto3.client('synthetics')


def get_canary_status():
    canary_name = os.environ['CANARY_NAME']
    response = client.get_canary(Name=canary_name)
    canary_status = response['Canary']['Status']['State']
    return canary_status


def lambda_handler(event, context):
    canary_name = os.environ['CANARY_NAME']
    client.start_canary(Name=canary_name)

    canary_status = get_canary_status()

    return {
        'canary_name': canary_name,
        'status': canary_status
    }
