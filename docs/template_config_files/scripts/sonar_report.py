#!/usr/bin/env python
import json
import os
import traceback
from time import time


# Report Portal versions >= 5.0.0:
from reportportal_client import ReportPortalService


def timestamp():
    return str(int(time() * 1000))


def my_error_handler(exc_info):
    """
    This callback function will be called by async service client when error occurs.
    Return True if error is not critical and you want to continue work.
    :param exc_info: result of sys.exc_info() -> (type, value, traceback)
    :return:
    """
    print("Error occurred: {}".format(exc_info[1]))
    traceback.print_exception(*exc_info)


def report_portal(endpoint,
                  project,
                  token,
                  launch_name,
                  launch_doc,
                  git_organization,
                  sonar_status,
                  status):
    service = ReportPortalService(endpoint=endpoint, project=project,
                                  token=token)

    # Start launch.
    service.start_launch(name=launch_name,
                         start_time=timestamp(),
                         description=launch_doc)

    # Start test item Report Portal versions >= 5.0.0:
    test = service.start_test_item(name="Sonar Pyapp Test",
                                   description=f"Sonar: [WEB UI](https://sonarcloud.io/organizations/{git_organization}/projects)",
                                   start_time=timestamp(),
                                   item_type="STEP",
                                   parameters={"SONAR STATUS": sonar_status,
                                               })

    # Finish test item Report Portal versions >= 5.0.0.
    service.finish_test_item(item_id=test, end_time=timestamp(), status=status)

    # Finish launch.
    service.finish_launch(end_time=timestamp())

    # Failure to call terminate() may result in lost data.
    service.terminate()


def main():
    git_organization = os.environ.get('ORGANIZATION')
    # Report Portal
    endpoint = os.environ.get('RP_ENDPOINT')
    project = os.environ.get('RP_PROJECT')
    # You can get UUID from user profile page in the Report Portal.
    token = os.environ.get('RP_TOKEN')
    launch_name = os.environ.get('RP_LAUNCH_NAME')
    launch_doc = os.environ.get('RP_LAUNCH_DOC')

    with open('result.json', 'r') as file:
        payload = json.load(file)
        sonar_status = payload['projectStatus']['conditions'][0]['status']
        print(sonar_status)
        if sonar_status == 'OK':
            status = 'PASSED'
        else:
            status = 'FAILED'
        report_portal(endpoint=endpoint, project=project, token=token, launch_name=launch_name,
                      launch_doc=launch_doc, status=status, git_organization=git_organization, sonar_status=sonar_status)


main()
