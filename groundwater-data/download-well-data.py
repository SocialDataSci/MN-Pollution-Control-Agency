from selenium import webdriver
import csv
from time import sleep

def get_values(tr):
    cells = tr.find_elements_by_tag_name('td')
    values = [cell.text for cell in cells]
    if len(values) > 3:
        if values[4] == 'N/A':
            values[4] = 'NA'
        else:
            anchor = cells[4].find_element_by_tag_name('a')
            values[4] = anchor.get_attribute('href')
    return values
        

with open('zipcodes.txt') as f:
    zipcodes = [line.strip() for line in f]
    

BASE_URL = 'http://cf.pca.state.mn.us/data/edaGwater/index.cfm#/geoAreaTypes=zipcode&specificGeoAreaCode=zipcode__%s&rowPerPage=All&page=1&sortBy=stationId&sortMethod=asc'

driver = webdriver.PhantomJS()
driver.set_window_size(1120, 550)

header_row = ['Zip_Code', 'Station_ID', 'Station_Name', 'Station_Type', 'County', 'CWI', 'Events']

with open('welldata.txt', 'w') as f:
    writer = csv.writer(f)
    writer.writerow(header_row)
    for zipcode in zipcodes:
        SEARCH_URL = BASE_URL % zipcode
        driver = webdriver.PhantomJS()
        driver.get(SEARCH_URL)
        table = driver.find_element_by_id("resultData")

        rows = table.find_elements_by_tag_name('tr')[1:]
        for i, row in enumerate(rows):
            values = get_values(row)
            if len(values) > 0:
                values = [zipcode] + values
                writer.writerow(values)
                print(values)
        driver.close()
            
        


