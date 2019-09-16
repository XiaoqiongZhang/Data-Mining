
print("\n importing... \n")

import requests
import pandas as pd
#from bs4 import BeautifulSoup

from selenium import webdriver
from selenium.webdriver.support.ui import Select
from selenium.webdriver.common.by import By

# website address
url = 'https://finance.yahoo.com/quote/IBM/options?p=IBM'

driver = webdriver.Chrome()
driver.get(url)
print(driver.find_element(By.TAG_NAME,"select").text)

select = Select(driver.find_element(By.TAG_NAME,"select"))
print(select.options)
print([o.text for o in select.options])
timeselected = 'January 17, 2020'
select.select_by_visible_text(timeselected)

html = driver.current_url

df_list = pd.read_html(html)

# extract from list
df_1 = df_list[0]
df_2 = df_list[1]

# save as CSV
file_name = timeselected + " text" 
df_1.to_csv(file_name+'_calls'+'.csv')
df_2.to_csv(file_name+'_puts'+'.csv')

driver.closeS