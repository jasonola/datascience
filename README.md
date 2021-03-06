# Data Scientist / Shiny app developper

## Jason Ola's data science portfolio 

Welcome to my github profile ! I'm Jason Ola, student at Universit√© de Lausanne in Computer Science for humanities, and Geography, and EPFL extension school graduate in [machine learning](https://github.com/jasonola/datascience/blob/master/certifications/EPFL_ML_certificate.pdf) as well as [communication and visualisation](https://github.com/jasonola/datascience/blob/master/certifications/EPFL_communication_visualisation_certificate.pdf). In this repository you will find the work I've done so far during my studies at UNIL, EPFL and personal projects regarding Data Science. 
Let me guide you through my files and projects !

## Python

### [Python Data Analysis](https://github.com/jasonola/datascience/tree/master/python_data_analysis)

Techs : Python, matplotlib, pandas, numpy, seaborn, sqlite3

Skills covered : data import, data cleaning, missing values handling, statistical summaries, data wrangling, regular expressions, data visualisation, database manipulation

[Beginner notebook](https://github.com/jasonola/datascience/tree/master/python_data_analysis/beginner_data_wrangling) : My first data wranglings, I read in the csv file, did some data cleaning, got insights and finally visualised results. The project was analysing the happiness of countries dataset.

[Advanced notebook](https://github.com/jasonola/datascience/tree/master/python_data_analysis/advanced_data_wrangling) : I did data wrangling on a much bigger and messy dataset that you can download here : [openfoods dataset](en.openfoodfacts.org.products.tsv)
For this project I had to find ways of cleaning the very messy data, choosing the right amount of data to keep or toss, how to replace missing/outlying data... All of this is outlined in details in the notebook.

### [Python Machine Learning](https://github.com/jasonola/datascience/tree/master/python_ml)

Techs : Python, pandas, numpy, matplotlib, seaborn, scikit-learn, flask, pyAudioAnalysis, keras

Skills covered : data cleaning, exploratory data analysis, feature engineering, data visualisation, insights, use of sk-learn pipes/grid search, regression, classification, unsupervised learning, neural networks, team work

This is where I showcase my work in machine learning with Python

In the [Regression](https://github.com/jasonola/datascience/tree/master/python_ml/regression) file, you will see my first touch with ML as I implemented a simple regression model with numpy in the [beginner ML](https://github.com/jasonola/datascience/blob/master/python_ml/regression/initial_ml_exercices/beginner_ml.ipynb) file. I also used my first sk-learn objects.
In the more advanced [regression](https://github.com/jasonola/datascience/blob/master/python_ml/regression/regression/regression_project.ipynb) file I worked on the Boston house price dataset. I started by doing some EDA to inform myself of the data, what is missing, what I should encode differently. My thought process is thoroughly explained throughout the notebook. I did multiple models : simple (fed with 2 most important features), intermediate (fed with 20 important features) and complex (fed with all features).

In the [classification](https://github.com/jasonola/datascience/tree/master/python_ml/classification) folder I worked on a classification task to classify 6 different types of vehicles. I started working with multiple files to separate my work better so it can be clearer. So in these files, I started by extracting my features from the images with an image generator. Then I did some EDA and finally I tried multiple machine learning algorithm and deep learning network to see which one performs best. You can see the results [here](https://github.com/jasonola/datascience/blob/master/python_ml/classification/09%20Results.ipynb). 

In the [Music genre recognition](https://github.com/jasonola/datascience/tree/master/python_ml/music_genre_recognition) file, I worked together with 2 partners : [Melinda Femminis](https://github.com/melindafemminis) and [Andrei Anikin](https://github.com/Andrei-ctrl). It's a project that aims to classify music genres. The project is fully discribed in the attached [readme](https://github.com/jasonola/datascience/blob/master/python_ml/music_genre_recognition/README.md). 

## R

Techs : R, tidyverse, ggplot2, lubridate, sf, tidygraph, ggraph, tsibble, patchwork, leaflet, shiny, testthat, golem, plumber

Skills covered : Reporting, data cleaning, data visualisation, chart reproduction, map creation, time series manipulation, graph visualisation, shiny app creation, tests

### [R Data visualisation](https://github.com/jasonola/datascience/tree/master/R_data_visualisation)

> To see my html reports you can click on the html file in any folder you would like to explore and then download it. If a html code comes up on your browser when you click download, just right click on the code and click "save as", then you can open the html file in your browser to see the report !

In these folders I showcase my first skills in data visualisation. 

In the [cartography](https://github.com/jasonola/datascience/tree/master/R_data_visualisation/cartography) file, I did my first maps. In this report I ploted gender employment gap onto Europe map, did some comparison between years, changed projections. 
In the [time series](https://github.com/jasonola/datascience/tree/master/R_data_visualisation/time_series) file, I worked with time series on the swiss market index and for the last part I did plots showing evolution of passengers traveling by Singapour airport. 
In the [network](https://github.com/jasonola/datascience/tree/master/R_data_visualisation/network_analysis) file, I ploted my first graphs on social connections between classmates.
In the [chart reproduction](https://github.com/jasonola/datascience/tree/master/R_data_visualisation/chart_reproduction) file, I reproduced in a simple manner the pie chart on the last page of [this pdf](https://www.vd.ch/fileadmin/user_upload/organisation/dfin/aci/fichiers_pdf/21004_2019.pdf). I also produced alternative charts where I argued why they are better than pie charts.

### [R Advanced Data visualisation](https://github.com/jasonola/datascience/tree/master/R_advanced_data_visualisation)

In these folders I showcase more in depth skills and analysis. 

In the [advanced time series](https://github.com/jasonola/datascience/tree/master/R_advanced_data_visualisation/Report_1) file, I did analysis on time series data from a cheese factory. I defined monitoring statistics and plotted Shewhart control charts with highlights of variations.

In the [advanced network](https://github.com/jasonola/datascience/tree/master/R_advanced_data_visualisation/Report_2) file, I did network analysis on relations between producers and composers working on a movie. I had to do some text wrangling to get the data from the pajek file (.paj), it is essentially a .txt file. In this project I computed and compared different types of clustering algorithms and plot the results.  

In the [cartography](https://github.com/jasonola/datascience/tree/master/R_advanced_data_visualisation/Report_3) file, I plotted maps to showcase dollars sent or recieved by country for diseases like HIV, tuberculosis and malaria. I also did some interactive leaflet map, multiple charts arrangements with patchwork to do an inset map, and a map of hotels and taxi spots in Paris using open street map API.  

In the [TidyTuesday project](https://github.com/jasonola/datascience/tree/master/R_advanced_data_visualisation/Report_4) file, I did a customised report showing data about volcanoes. This project was aimed to showcase creativity and resourcefulness. You can find the tidytuesday's repo folder for this project [here](https://github.com/rfordatascience/tidytuesday/blob/master/data/2020/2020-05-12/readme.md)

> Check out my [gallery](https://github.com/jasonola/datascience/tree/master/gallery/gallery) where you can find samples of my visualisations that I did in my projects in .png format as well as the [code](https://github.com/jasonola/datascience/tree/master/gallery) I used to compute them.

### [R script](https://github.com/jasonola/datascience/tree/master/R_script)

This is a project I did as part of an examination for a statistic class (M√©thodes Quantitatives IV) at Universit√© de Lausanne using R. In this project I coded a statistical test from scratch, did a linear regression, plotted a residue diagram, some cartography exercise too and all plots are saved in pdf form. I used the data I worked with and tweeked in [another project](https://github.com/jasonola/datascience/tree/master/spss) using SPSS. More details are written in comments in the script file (in french).

### [R Shiny](https://github.com/jasonola/datascience/tree/master/R_shiny)

[Fitness app](https://github.com/jasonola/datascience/tree/master/R_shiny/fitness_app) : It's an app using dummy data about fitness members. There are 3 different panels showing different charts about members gender, subscription and BMI category. 

[Pokestats](https://github.com/jasonola/datascience/tree/master/R_shiny/Pokestats) : It's a more simple app than the fitness app showing data about pokemon stats in an interactive way. However, I used the Golem framework to build the app with modules. This makes the app scalable and easier to use among other devs, and multiple folders are created as would be a package, and moreover, it is easier to conduct tests.

[GeoGame](https://github.com/jasonola/datascience/tree/master/R_shiny/GeoGame) : Full app using the golem framework to build a geography based quiz. There are 3 different quizzes, one on guessing a random selected country highlighted on a map, another on capitals (also with maps) and the last one with flags ! There is also an additionnal tab with info on different countries to compare. 


### [R Plumber](https://github.com/jasonola/datascience/tree/master/R_plumber)
[Pokemon Stats Calculator](https://github.com/jasonola/datascience/tree/master/R_plumber/pokemon_calculator) : Creation of an HTTP API with the `plumber` package. It is an API endpoint to calculate stats of pokemon according to its level, IVs, EVs and nature. (Still in progress)

## [SPSS](https://github.com/jasonola/datascience/tree/master/spss) 

Techs : IBM SPSS Statistics, LaTeX

Skills : Scientific report with LaTeX, Statistical analysis / interpretation

This is a project I did as part of an examination in a statistics class (M√©thode quantitatives IV) at Universit√© de Lausanne. You can find the [.sps](https://github.com/jasonola/datascience/blob/master/spss/syntaxe.sps) file to compute the analysis on the data, as well as a thorough [report](https://github.com/jasonola/datascience/blob/master/spss/analyses_crimes_cantons.pdf) (in french) written in LaTeX. 
