# Selenium test example
# Put your functions with test to `class TestApp:`
import time
from mimetypes import guess_type
import pytest
from selenium import webdriver
from selenium.webdriver import DesiredCapabilities
from selenium.webdriver.common.by import By
from reportportal_client import RPLogger
import logging
import os

link = os.environ.get('APP_TARGET_URL')  # "https://my_project.com/"
selenium_server_url = os.environ.get('SELENIUM_SERVER_URL')  # "http://127.0.0.1:4444/wd/hub"


@pytest.fixture(scope="session")
def rp_logger():
    logger = logging.getLogger(__name__)
    logger.setLevel(logging.INFO)
    logging.setLoggerClass(RPLogger)
    return logger


@pytest.fixture(scope="session")
def browser():
    print("\nstart browser for test..")
    browser = webdriver.Remote(
        command_executor=selenium_server_url,
        desired_capabilities=DesiredCapabilities.FIREFOX
    )
    # browser = webdriver.Chrome()
    yield browser
    print("\nquit browser..")
    browser.quit()


class TestApp:

    # Test for failing testing, uncomment it if need one test will be failed
    # def test_fail(self):
    #     assert (1 == 2)

    # def test_success(self):
    #     print('Pass test 2 = 2 success')
    #     assert (2 == 2)

    # def test_open_title(self, browser, rp_logger):
    #     browser.get(link)
    #     browser.save_screenshot("ss.png")
    #     image = "./ss.png"
    #     with open(image, "rb") as image_file:
    #         rp_logger.info("ScreenShot Title Page",
    #                        attachment={"name": "ss.png",
    #                                    "data": image_file.read(),
    #                                    "mime": guess_type(image)[0] or "application/octet-stream"},
    #                        )
    #     time.sleep(1)
    #     print("Title is : " + browser.title)

    def test_login_page(self, browser):
        browser.get(link)
        test1 = browser.find_element(by=By.CSS_SELECTOR, value="span.glyphicon.glyphicon-log-in")
        test1.click()
        time.sleep(1)

    def test_sing_up(self, browser):
        browser.get(link)
        browser.find_element(by=By.LINK_TEXT, value='Sign Up').click()
        time.sleep(1)

    def test_post(self, browser):
        browser.get(link)
        for handle in browser.window_handles:
            browser.switch_to.window(handle)
            browser.find_element(by=By.LINK_TEXT, value='Posts').click()
            browser.find_element(by=By.CLASS_NAME, value='close')
            assert "Your token is unauthorized! LogIn, please" in browser.find_element(by=By.XPATH,
                                                                                       value="/html/body/div/div[1]").text