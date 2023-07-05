#!/usr/bin/python3.6
import urllib3
import json
import os

http = urllib3.PoolManager()


def lambda_handler(event, context):
    teams_url = os.environ['TEAMS_HOOK_URL']
    slack_url = os.environ['SLACK_HOOK_URL']
    msg = {
        "text": event['Records'][0]['Sns']['Message']
    }
    encoded_msg = json.dumps(msg).encode('utf-8')
    teams_resp = http.request('POST', teams_url, body=encoded_msg)
    slack_resp = http.request('POST', slack_url, body=encoded_msg)
    print({
        "message": event['Records'][0]['Sns']['Message'],
        "status_code": teams_resp.status,
        "response": teams_resp.data
    })
    print({
        "message": event['Records'][0]['Sns']['Message'],
        "status_code": slack_resp.status,
        "response": slack_resp.data
    })