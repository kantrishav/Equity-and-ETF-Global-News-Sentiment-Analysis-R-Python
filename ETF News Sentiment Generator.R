
install.packages("textdata")
install.packages("tidyRSS")
install.packages("rvest")
install.packages("urltools")
library(rvest)
library(textdata)
library(tidyRSS)
library(tibble)
library(tidytext)
library(dplyr)
library(ggplot2)
library(urltools)
library(cowplot)
library(wordcloud2) 


# STEP 1

news_link <- read.csv("data_file.csv")


df1 <- data.frame()
df2 <- data.frame()

for(n in 1:nrow(news_link)){
  # Initialize the 'response' variable
  response <- NULL
  
  link <- news_link[n,1]
  link <- as.character(link)
  
  print(link)
  # Use tryCatch to handle the timeout error
  tryCatch({
    response <- read_html(link)
    para_read <- length(html_text(html_nodes(response, 'p')))
  }, error = function(e) {
    cat("Timeout error occurred: ", conditionMessage(e), "\n")
  })
  
  # Check if 'response' is not NULL
  if (!is.null(response)) {
    # Continue with your code for a successful response
    
    print("success")
    
    msg <- c("Pass")
    
    df1 <- data.frame(url = link , status = msg , len = para_read)
    df2 <- rbind(df1,df2)
    
    
    
  } else {
    
    
    msg <- c("Fail")
    
    df1 <- data.frame(url = link , status = msg , len = para_read)
    df2 <- rbind(df1,df2)
    cat("Website Error\n")
    
  }
  
}

# STEP 2



news_link <- df2 %>% filter(status == "Pass" , len > 0)

class(news_link)
news_link <- as_tibble(news_link)

capture_single_link <- news_link

bi <- data.frame()
corpus <- data.frame()


news_combined <- data.frame()
news_combined <- news_combined %>% mutate(text = "")
news_combined <- news_combined %>% mutate(link = "")
news_combined <- news_combined %>% mutate(num = "" )




domain_df <- data.frame()
domain_df <- domain_df %>% mutate(name  = "")

news_combined_current <- data.frame()
combined_affin <- data.frame()

#for(n in 1:nrow(news_link)){

for(n in 1:nrow(news_link)){
  
  capture_single_link <- news_link[n,1]
  list_news <-  as.list(capture_single_link)
  list_news <- as.vector(list_news)
  list_news <- as.character(list_news)
  
  domain_name <- sub("^https?://(www\\d?\\.)?", "", list_news)
  domain_name <- sub("/.*", "", domain_name)
  
  domain_df <- rbind(domain_df , data.frame(name = domain_name))
  
  # print(domain_name)
  
  
  print(paste("Code no:" ,n , list_news)) 
  
  
  htmlwee <- read_html(list_news)
  
  
  
  para <- html_text(html_nodes(htmlwee, 'p'))
  
  print(length(para))
  
  
  #para <-  ifelse( length(para) >0 , para , neutral_list)  # --> this is done because paragraph was not being read of some website 
  
  
  news_combined_current <- cbind(text = para , link = domain_name , num = n)
  
  news_combined <- rbind(news_combined , news_combined_current)
  
  
  #news_combined <- as.data.frame(news_combined)
  
  
  #  View(news_combined)
  
  len_para <- length(para)
  
  data <- para
  data_df <- tibble(line = 1:len_para , text = data)
  
  data_df <- data_df %>% unnest_tokens(  input = text , output = word )
  
  data_df <- data_df %>% mutate(line_number = row_number())
  
  data_df<- data_df %>% anti_join(stop_words)
  
  bing_sent <- get_sentiments("bing")
  affin_sent <- get_sentiments("afinn")
  
  data_bing <- data_df %>% inner_join(bing_sent)
  
  data_affin <- data_df %>% inner_join(affin_sent)
  
  df_single_affin <- data.frame(Link = list_news , Domain = paste(n,":" , domain_name ) , Overall_Sentiment = sum(data_affin$value) )
  
  combined_affin <- rbind(combined_affin , df_single_affin )
  
  
  
  plot <-   data_bing %>% group_by(sentiment) %>% 
    summarise(Frequency = n()) %>% arrange(desc(Frequency)) %>%
    ggplot(aes(x=sentiment , y = Frequency , col = sentiment , fill = sentiment)) + geom_bar(stat = "identity")  + 
    ggtitle(paste("What's the world outlook on QQQ ETF?" , domain_name))
  
  print(plot)
  
  
  combining <-  data_bing %>% group_by(sentiment) %>% 
    summarise(Frequency = n()) %>% arrange(desc(Frequency)) %>% 
    mutate(source = domain_name) %>% mutate(Frequency = ifelse(sentiment == 'negative' , Frequency*-1 , Frequency ))
  
  combining  <- combining %>% mutate(source = paste(n,":" , source) )
  
  bi <- rbind(combining , bi)
  
  
  
  
  corpus_temp <- data_df %>% inner_join(bing_sent) %>% mutate(Domain = domain_name , Link = paste("News Source:" ,n))
  
  corpus <- rbind(corpus_temp , corpus)
  
}



# STEP 3


domain_df <- domain_df %>% group_by(name) %>% summarise( freq = n())


a1<- ggplot(data = combined_affin , aes(x = Overall_Sentiment)  ) + geom_histogram( fill = "green") + ggtitle( "ETF Anticipation Density Curve")


a2<- ggplot(data = combined_affin, aes(x = Overall_Sentiment)) +
  geom_density(color = "black" , size = 2) 

combined_plot <- bi %>% ggplot(aes(source ,Frequency , fill = sentiment  )) + geom_bar(stat = "identity")  + ggtitle("Golbal Media Sentiment on QQQ ETF") +  guides(fill = "none")

c <- combined_plot


d <- wordcloud2(data=domain_df, size=1.6)


plot_grid(c , a1,a2 , nrow = 2)



