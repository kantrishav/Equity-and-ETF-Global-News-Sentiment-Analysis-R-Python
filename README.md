# Equity-and-ETF-Global-News-Sentiment-Analysis-R-Python
![Screenshot 2023-12-22 041613](https://github.com/kantrishav/Equity-and-ETF-Global-News-Sentiment-Analysis-R-Python/assets/28995985/64d5732c-9160-4034-b530-9798eba00175)

More than eight-in-ten U.S. adults (86%) say they get news from a smartphone, computer or tablet. Stock news and editorials are one of the biggest source of information on companies financials , goals , outreach , environment commitment , downsides and many more attributes. An attentive investor wants to read as many editorial and news blogs on their favorite equities , ETFs or any other assest and debt class.
Mostly , a average person can read maximun 3-5 news blogs daily. 
As a human it is difficult to read all news available on internet before taking any market decision. 
Hence , the idea of StockIQ , a simple sentiment analysis model that capture all the news website according to a reader choice and provide them a visual alternative i.e news in form of vizualisation.

The project consists of 4 Parts:

1 : Searching all news websites link according to user choice of companies.(Python is Used For This Process)

2 : Extracting content from each website and saving it in a data structure.(R is Used For This Process)

3:  Analyzing the extracted courpus and performing , Unigram , Bi-gram and N-gram , tf-idf analysis (R is Used)

4: Visualizing the analysis using ggplot2 , shiny and plotly. (R is Used For This Process)


<img width="580" alt="image" src="https://github.com/kantrishav/Equity-and-ETF-Global-News-Sentiment-Analysis-R-Python/assets/28995985/e003928c-31ce-460a-85ec-870ac57a2da3">


One crucial aspect of this model is the incorporation of the Affin lexicon, a powerful tool in natural language processing. The Affin lexicon, short for Affective Norms for English Words, provides a comprehensive sentiment analysis framework by assigning sentiment scores to words based on their emotional connotations. Integrating this lexicon into the model enhances its ability to capture nuances in language, enabling a more accurate understanding of sentiment within the context of financial news.

<img width="584" alt="image" src="https://github.com/kantrishav/Equity-and-ETF-Global-News-Sentiment-Analysis-R-Python/assets/28995985/a24f2d9b-701f-4f78-9882-9c5637cb3624">

The R block code is also built to tackle non-working website that can't be scrapped. Websites which passes via this block is used for generating insights.

##Step 1: Data Collection

Package Installation: The required R packages (textdata, tidyRSS, rvest, urltools, tibble, tidytext, dplyr, ggplot2, cowplot, wordcloud2) are installed.

Library Loading: The necessary libraries are loaded into the R environment.

Data Loading: The code reads a CSV file named "data_file.csv" containing news links related to the QQQ ETF.

Web Scraping Loop: The code iterates through each news link, attempts to fetch the HTML content, and checks for successful retrieval. If successful, it prints "success" and records the URL, status ("Pass"), and the number of paragraphs in the news article. If unsuccessful, it prints an error message and records the URL, status ("Fail"), and 0 for the number of paragraphs.

##Step 2: Data Processing and Sentiment Analysis

Filtering: URLs with a status of "Pass" and a positive number of paragraphs are retained.

Loop for Sentiment Analysis: For each retained URL, the code extracts the domain name, reads the HTML content, and processes the paragraphs.

Text Processing: The paragraphs are tokenized, filtered for stop words, and sentiment analysis is performed using the Bing and Afinn lexicons.

Data Aggregation: The results of sentiment analysis are aggregated and visualized using ggplot2.

##Step 3: Visualizations

Domain Frequency: The frequency of each domain is calculated and visualized.

Overall Sentiment Density Curve: Histogram and density plots visualize the overall sentiment scores.

Global Media Sentiment: Bar plots depict the sentiment distribution across different media sources.

Word Cloud: A word cloud is generated based on the frequency of domain names.

Final Visualization: The plot_grid function combines all the visualizations into a single display for easy interpretation.
