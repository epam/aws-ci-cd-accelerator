#!/usr/bin/python3.8
import json
import os
import urllib3
import boto3

http = urllib3.PoolManager()
client = boto3.client('ssm')


def get_ssm_parameter(name):
    try:
        response = client.get_parameter(
            Name=name,
            WithDecryption=True
        )
        return response
    except (client.exceptions.InternalServerError, client.exceptions.InvalidKeyId,
            client.exceptions.ParameterNotFound, client.exceptions.ParameterVersionNotFound) as e:
        print(f"Error getting SSM parameter '{name}': {e}")
        return None


def lambda_handler(event, context):
    repo_name = os.environ.get('REPO_NAME')
    teams_url = get_ssm_parameter(f'/{repo_name}/teams/web/hook')
    slack_url = get_ssm_parameter(f'/{repo_name}/slack/web/hook')

    msg = {
        "text": event['Records'][0]['Sns']['Message']
    }
    encoded_msg = json.dumps(msg).encode('utf-8')

    if teams_url:
        teams_resp = http.request('POST', teams_url['Parameter']['Value'], body=encoded_msg)
        print({
            "message": event['Records'][0]['Sns']['Message'],
            "status_code": teams_resp.status,
            "response": teams_resp.data
        })

    if slack_url:
        slack_resp = http.request('POST', slack_url['Parameter']['Value'], body=encoded_msg)
        print({
            "message": event['Records'][0]['Sns']['Message'],
            "status_code": slack_resp.status,
            "response": slack_resp.data
        })
