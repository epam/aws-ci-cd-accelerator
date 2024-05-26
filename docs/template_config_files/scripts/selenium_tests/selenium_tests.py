# Put your Selenium test code here
# There is an example of tests for an application
import os
import logging
import pytest
from selenium import webdriver
from selenium.webdriver.common.by import By
# from selenium.webdriver.firefox.options import Options as FirefoxOptions
from selenium.webdriver.chrome.options import Options as ChromeOptions
from reportportal_client import RPLogger

APP_TARGET_URL = os.environ.get('APP_TARGET_URL')
SELENIUM_SERVER_URL = os.environ.get('SELENIUM_SERVER_URL')


@pytest.fixture(scope="session")
def rp_logger():
    logger = logging.getLogger(__name__)
    logger.setLevel(logging.INFO)
    logging.setLoggerClass(RPLogger)
    return logger

# @pytest.fixture(scope="session")
# def browser():
#     print("\nstart browser for test..")
#     options = FirefoxOptions()
#     browser = webdriver.Remote(
#         command_executor=SELENIUM_SERVER_URL,
#         options=options
#     )
#     yield browser
#     print("\nquit browser..")
#     browser.quit()


@pytest.fixture(scope="session")
def browser():
    print("\nstart chrome browser for test..")
    options = ChromeOptions()
    options.add_argument("--headless")  # run headless Chrome
    browser = webdriver.Remote(
        command_executor=SELENIUM_SERVER_URL,
        options=options
    )
    yield browser
    print("\nquit chrome browser..")
    browser.quit()

class TestApp:

    def test_01_signup_form(self, browser):
        browser.get(APP_TARGET_URL)

        # Test Signup form fields
        username_input = browser.find_element(by=By.XPATH,
                                              value="//div[@class='note'][2]/div/form/input[@name='username']")
        password_input = browser.find_element(by=By.XPATH,
                                              value="//div[@class='note'][2]/div/form/input[@name='password']")
        email_input = browser.find_element(by=By.XPATH,
                                           value="//div[@class='note'][2]/div/form/input[@name='email']")
        signup_submit_btn = browser.find_element(by=By.XPATH,
                                                 value="//div[@class='note'][2]/div/form/input[@type='submit']")

        username_input.send_keys("test_user")
        password_input.send_keys("test_password")
        email_input.send_keys("test@example.com")
        # time.sleep(5)
        signup_submit_btn.click()

    def test_02_login_form(self, browser):
        browser.get(APP_TARGET_URL)

        # Test Login form fields
        username_input = browser.find_element(by=By.XPATH,
                                              value="//div[@class='note'][1]/div/form/input[@name='username']")
        password_input = browser.find_element(by=By.XPATH,
                                              value="//div[@class='note'][1]/div/form/input[@name='password']")
        login_submit_btn = browser.find_element(by=By.XPATH,
                                                value="//div[@class='note'][1]/div/form/input[@type='submit']")

        username_input.send_keys("test_user")
        password_input.send_keys("test_password")
        # time.sleep(5)
        login_submit_btn.click()

        assert "Pending" == browser.find_element(By.XPATH, value="/html/body/nav/div/div/p").text
