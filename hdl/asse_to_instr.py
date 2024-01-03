from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.common.keys import Keys
import time

PATH = "F:\SideProject\Python Pratice\riscv_conv\chromedriver.exe"
driver = webdriver.Edge()

driver.get("https://luplab.gitlab.io/rvcodecjs/")
print(driver.title)
# for table in driver.find_elements(By.CSS_SELECTOR, "[aria-label=XXXX]"):
#     for tr in table.find_elements(By.TAG_NAME, 'tr'):
#         td = tr.find_elements(By.XPATH, './/td')
#         print(td.text)
f = open(".\txt_file\riscv.txt", "r")
f_write = open(".\txt_file\instr.txt", "w")
f_write2 = open(".\txt_file\assem.txt", "w")
# print(f.read())

zero = bin(0)

for line in f:
    if line.startswith('NOP') :
        # print("000000000000000")
        print(zero[2:].zfill(32))
        f_write.write(zero[2:].zfill(32) + " // " + line)
        f_write2.write("addi x0, x0, 0" + "\n")
    else :
        search = driver.find_element(By.ID, 'search-input')
        search.send_keys(line + Keys.ENTER)

        instr = driver.find_element(By.ID, 'hex-data')
        b = bin(int(instr.text, 16))
        # print(b[2:])
        print(b[2:].zfill(32))
        f_write.write(b[2:].zfill(32) + " // " + line)
        f_write2.write(line)
        search.clear()
    
f.close()
f_write.close()
f_write2.close()

time.sleep(1)
driver.quit()