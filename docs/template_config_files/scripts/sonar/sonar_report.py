import os
import sys
import pytest
import requests
import logging
from reportportal_client import RPLogger

# Read environment variables or set default hardcoded values
organization = os.environ.get('ORGANIZATION', "")
sonar_url = os.environ.get('SONAR_URL', "")
login = os.environ.get('SONAR_TOKEN', "")
project_key = os.environ.get('PROJECT_KEY', "")
pull_request_id = os.environ.get('PULL_NUM', None)

@pytest.fixture(scope="session")
def rp_logger():
    logger = logging.getLogger(__name__)
    logger.setLevel(logging.INFO)
    logging.setLoggerClass(RPLogger)
    return logger

def get_sonar_issues():
    issues_api_url = (
            sonar_url
            + "/api/issues/search?projects="
            + project_key
            + "&statuses=OPEN,REOPENED,CONFIRMED"
    )

    if pull_request_id:
        issues_api_url += "&pullRequest=" + pull_request_id

    response = requests.get(issues_api_url, auth=(login, ""))
    response.raise_for_status()
    issues = response.json()['issues']
    return issues

def get_sonar_hotspots():
    hotspots_api_url = sonar_url + "/api/hotspots/search?projectKey=" + project_key + "&ps=500"
    if pull_request_id:
        hotspots_api_url += "&pullRequest=" + pull_request_id
    response = requests.get(hotspots_api_url, auth=(login, ""))
    response.raise_for_status()
    hotspots = response.json()['hotspots']
    return hotspots

def get_quality_gate_status():
    quality_gate_api_url = sonar_url + "/api/qualitygates/project_status?projectKey=" + project_key
    if pull_request_id:
        quality_gate_api_url += "&pullRequest=" + pull_request_id
    response = requests.get(quality_gate_api_url, auth=(login, ""))
    response.raise_for_status()
    quality_gate_status = response.json()['projectStatus']['status']
    return quality_gate_status

issues = get_sonar_issues()
hotspots = get_sonar_hotspots()

def pytest_generate_tests(metafunc):
    if 'issue_test' in metafunc.fixturenames and issues:
        severity_values = {'INFO': 1, 'MINOR': 2, 'MAJOR': 3, 'CRITICAL': 4, 'BLOCKER': 5}
        sorted_issues = sorted(issues, key=lambda x: severity_values[x['severity']], reverse=True)
        ids = [f"issue_{i + 1}: {issue['component']}" for i, issue in enumerate(sorted_issues)]
        metafunc.parametrize('issue_test', sorted_issues, ids=ids, indirect=True)

    if 'hotspot_test' in metafunc.fixturenames and hotspots:
        ids = [f"hotspot_{i + 1}: {hotspot['component']}" for i, hotspot in enumerate(hotspots)]
        metafunc.parametrize('hotspot_test', hotspots, ids=ids, indirect=True)

class TestSonar:
    @pytest.fixture
    def issue_test(self, request):
        issue = request.param
        return issue['component'], issue['severity'], issue['type'], issue['rule']

    @pytest.mark.skipif(not issues, reason="No Issues found")
    def test_issues(self, rp_logger, issue_test):
        component, severity, type_error, rule = issue_test
        rp_logger.info(f"Component: {component}")
        rp_logger.info(f"Severity: {severity}")
        rp_logger.info(f"Type: {type_error}")
        rp_logger.info(f"Rule: {rule}")

    @pytest.fixture
    def hotspot_test(self, request):
        hotspot = request.param
        return hotspot['component'], hotspot['vulnerabilityProbability']

    @pytest.mark.skipif(not hotspots, reason="No Hotspots found")
    def test_hotspots(self, rp_logger, hotspot_test):
        component, vulnerability_probability = hotspot_test

        assert component, "Hotspot Component is missing"
        assert vulnerability_probability, "Hotspot Vulnerability Probability is missing"

        rp_logger.info(f"Hotspot Component: {component}")
        rp_logger.info(f"Hotspot Vulnerability Probability: {vulnerability_probability}")

def quality_gate_status_check():
    status = get_quality_gate_status()
    if status != 'OK':
        print(f"Quality gate status is {status}")
        exit(1)
    else:
        print(f"Quality gate status: {status}")
        exit(0)

if __name__ == "__main__":
    if "--status-check" in sys.argv:
        quality_gate_status_check()
