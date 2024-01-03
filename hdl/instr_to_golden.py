from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.common.keys import Keys
import time

PATH = "F:\SideProject\Python Pratice\riscv_conv\chromedriver.exe"
driver = webdriver.Edge()

driver.get("https://www.cs.cornell.edu/courses/cs3410/2019sp/riscv/interpreter/?fbclid=IwAR1PbauCSyt1AUaKQPjek2A7u18HxpXzLQ52k8DtjIbHnacCCV4hDEgujac")
print(driver.title)
# for table in driver.find_elements(By.CSS_SELECTOR, "[aria-label=XXXX]"):
#     for tr in table.find_elements(By.TAG_NAME, 'tr'):
#         td = tr.find_elements(By.XPATH, './/td')
#         print(td.text)
f = open(".\txt_file\assem.txt", "r")
# print(f.read())
f_write = open(".\txt_file\golden.txt", "w")

zero = bin(0)

for line in f:
    if line.startswith('NOP') :
        # print("000000000000000")
        print("")
    else :
        search = driver.find_element(By.ID, 'code')
        search.send_keys(line + '\n')

driver.find_element(By.ID, 'run').click()
time.sleep(3)

driver.find_element(By.ID, 'stop').click()

regs = []

table = driver.find_element(By.ID, 'registers')
for td in table.find_elements(By.XPATH, './/td[3]'):
    print(td.text)
    regs.append(td.text)

print(regs)

for i in range(32):
    f_write.write(regs[i] + " // r" + str(i) + "\n")


time.sleep(5)

driver.quit()