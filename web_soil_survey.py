##This script accesses the USDA Web Soil Survey through SQL. The script is practically useless without extensive knowlede of
##the different tables and table relations of the Web Soil Survey. These can be found at the following website: https://sdmdataaccess.nrcs.usda.gov/QueryHelp.aspx


import pandas as pd
import requests


#This function accepts a single parameter in the form of a SQL query
def getsoil(q):
    #The script accesses the soil data mart's rest API and sends a POST request in the form of a query on line 14
    url = "https://sdmdataaccess.sc.egov.usda.gov/tabular/post.rest"
    format = {'query': q, 'format': "json+columnname+metadata" }
    r = requests.post(url = url, data = format)
    #If the request is good it will return a pandas dataframe, otherwise it will print the error code
    if r.ok == True:
        dct = r.json()
        data = dct['Table']
        data[0], data[1] = data[1], data[0]
        data = data[1:]
        df = pd.DataFrame(data[1:], columns= data[0])
    else:
        print(r.status_code)
    return df
