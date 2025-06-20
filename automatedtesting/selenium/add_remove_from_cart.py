# #!/usr/bin/env python
from selenium import webdriver
from selenium.webdriver.chrome.options import Options as ChromeOptions
from selenium.webdriver.common.by import By
import time
import logging
import datetime

# Start the browser and login with standard_user
def login (user, password):
    print (f'{datetime.datetime.now()} - SeleniumTest: Starting the browser...')
    # --uncomment when running in Azure DevOps.
    options = ChromeOptions()
    options.add_argument("--headless") 
    options.add_argument("--no-sandbox") 
    options.add_argument("--disable-popup-blocking") 
    options.add_argument("--disable-application-cache") 
    options.add_argument("--guest") 
    prefs = {"credentials_enable_service": False,
        "profile.password_manager_enabled": False}
    options.add_experimental_option("prefs", prefs)
    driver = webdriver.Chrome(options=options)
    print (f'{datetime.datetime.now()} - SeleniumTest: Browser started successfully. Navigating to the demo page to login.')
    driver.get('https://www.saucedemo.com/')
    print (f'{datetime.datetime.now()} - SeleniumTest: Attempting to login into the store with the user {user}.')
    driver.find_element(By.ID, "user-name").send_keys(user)
    driver.find_element(By.ID, "password").send_keys(password)
    driver.find_element(By.ID, "login-button").click()
    time.sleep(2)

    # Search for the shopping cart container to check if the login was successful
    shopping_cart = driver.find_elements(By.CSS_SELECTOR, ".shopping_cart_container")
    if len(shopping_cart) == 1:
        print (f'{datetime.datetime.now()} - SeleniumTest: Login successful.')
    else:
        print (f'{datetime.datetime.now()} - SeleniumTest: Login failed.')
    
    assert len(shopping_cart) == 1, "Login process failed."
    return driver

def add_items_to_cart (driver):
    print (f'{datetime.datetime.now()} - SeleniumTest: Adding products to cart.')
    # Search for the products
    articles = driver.find_elements(By.CSS_SELECTOR, "div.inventory_item")
    total_articles = len(articles)
    print (f'{datetime.datetime.now()} - SeleniumTest: Found {total_articles} articles')
    for article in articles:
        name = article.find_element(By.CSS_SELECTOR, ".inventory_item_name").text
        button = article.find_element(By.CSS_SELECTOR, "button.btn_inventory")
        print (f'{datetime.datetime.now()} - SeleniumTest: Adding {name} to the cart')
        button.click()

    cart_icon = driver.find_element(By.CSS_SELECTOR, "a.shopping_cart_link")
    cart_item_count = int(cart_icon.text)
    print (f'{datetime.datetime.now()} - SeleniumTest: Articles in cart: {cart_item_count}')
    assert total_articles == cart_item_count, 'Not all the articles were added to the shopping cart'

def remove_items_from_cart(driver):
    print (f'{datetime.datetime.now()} - SeleniumTest: Removing products to cart.')
    # Search for the products
    articles = driver.find_elements(By.CSS_SELECTOR, "div.inventory_item")
    total_articles = len(articles)
    print (f'{datetime.datetime.now()} - SeleniumTest: Found {total_articles} articles')
    for article in articles:
        name = article.find_element(By.CSS_SELECTOR, ".inventory_item_name").text
        button = article.find_element(By.CSS_SELECTOR, "button.btn_inventory")
        print (f'{datetime.datetime.now()} - SeleniumTest: Removing {name} to the cart')
        button.click()

    cart_icon = driver.find_element(By.CSS_SELECTOR, "a.shopping_cart_link")
    if len(cart_icon.text) == 0:
        cart_item_count = 0
    else:
        cart_item_count = int(cart_icon.text)

    print (f'{datetime.datetime.now()} - SeleniumTest: Articles in cart: {cart_item_count}')
    assert cart_item_count == 0, 'Not all the articles were removed from the shopping cart'

print (f'{datetime.datetime.now()} - SeleniumTest: Start testing.')
driver = login('standard_user', 'secret_sauce')
add_items_to_cart(driver)
remove_items_from_cart(driver)
print (f'{datetime.datetime.now()} - SeleniumTest: End testing.')
