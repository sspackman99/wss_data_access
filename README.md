# Soil Data

This repository documents how to access the USDA's [Web Soil Survey](https://websoilsurvey.sc.egov.usda.gov/App/HomePage.htm) with Python.


## The code

**soildb.r** is the r function that accesses the Web Soil Survey API

**web_soil_survey.py** is the python function I wrote loosely based on the function in **soildb.r**

**web_soil_survey_sample.ipynb** is a jupyter notebook giving a sample query that could be passed into **web_soil_survey.py**

I would have also uploaded the dataset I use for my blog posts, but with 100,000 rows it was too large for Github to handle... you can get the same data by using the sample query I have here and changing the "TOP" number to 100,000. The API will only allow you to get 100,000 rows max with every query

[Here is a link](https://sdmdataaccess.nrcs.usda.gov/) to the help page that will direct you to answers to your WSS questions


## The story

Check out [my post on my blog Data Science Magic](https://www.datasciencemagic.org/2022/10/21/Getting-Dirty-Getting-Data.html) if you want to learn more about my inspiration for the project and see what I did!
