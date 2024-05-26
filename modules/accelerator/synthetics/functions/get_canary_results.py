import os
import boto3
from datetime import datetime, timedelta

client = boto3.client('synthetics')
cloudwatch = boto3.client('cloudwatch')


def get_canary_success_rate(canary_name):
    # Get Canary metadata
    response = client.get_canary(Name=canary_name)
    canary = response['Canary']

    # Get the current time and calculate the start time
    end_time = datetime.utcnow()
    start_time = end_time - timedelta(seconds=canary['Schedule']['DurationInSeconds'] * 2) if canary['Schedule']['DurationInSeconds']  != 0 else end_time - timedelta(minutes = 10)

    # Set default period value to 60 seconds if canary duration is 0
    period = canary['Schedule']['DurationInSeconds'] if canary['Schedule']['DurationInSeconds'] != 0 else 60

    # Get CloudWatch metric data for the Canary success rate
    metric_data = cloudwatch.get_metric_data(
        MetricDataQueries=[
            {
                'Id': 'm1',
                'MetricStat': {
                    'Metric': {
                        'Namespace': 'CloudWatchSynthetics',
                        'MetricName': 'SuccessPercent',
                        'Dimensions': [
                            {
                                'Name': 'CanaryName',
                                'Value': canary_name
                            }
                        ]
                    },
                    'Period': period,
                    'Stat': 'Average'
                },
                'ReturnData': True,
            },
        ],
        StartTime=start_time,
        EndTime=end_time
    )

    success_rate = metric_data['MetricDataResults'][0]['Values'][0]
    return success_rate


def lambda_handler(event, context):
    canary_name = os.environ['CANARY_NAME']
    success_rate = get_canary_success_rate(canary_name)

    success_threshold = float(os.environ["SUCCESS_THRESHOLD"])
    result = "SUCCESS" if success_rate >= success_threshold else "FAILURE"

    return {
        'success_rate': success_rate,
        'result': result
    }
