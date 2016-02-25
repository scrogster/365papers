library(gsheet)
library(lubridate)
library(dplyr)
library(tidyr)
library(ggplot2)


papers<-gsheet2tbl('https://docs.google.com/spreadsheets/d/1Z_4x3w2SgpOdHQ028IiPEgbB6CSFC0YT3oUymE5UoBE/edit?usp=sharing')

#add some sensible variable names
names(papers)<-c("DateTime", "Tweeter", "Content", "PaperURL", "TweetLink")
papers$DateTime<-mdy_hm(papers$DateTime) 

##
tidy_papers<-papers %>%
              mutate(Hour=hour(DateTime), YearDay=yday(DateTime), 
                     DOW=wday(DateTime,label=TRUE, abbr=TRUE), PaperNum=order(DateTime))

#Plot diurnal distribution of tweets
ggplot(tidy_papers, aes(x=Hour))+
  geom_histogram(binwidth = 1, fill="red", col="red", alpha=0.7) +
  theme_bw()
ggsave(file="diurnal-hist.png")

#Plot distribution by day of week
ggplot(tidy_papers, aes(x=DOW))+
  geom_bar( fill="red", col="red", alpha=0.7) +
  xlab("")+
  theme_bw()
ggsave(file="weekly-hist.png")

#Plot cumulative sum vs time
ggplot(tidy_papers, aes(x=YearDay, y=PaperNum))+
  geom_step(col="red")+
  xlim(c(1, 365))+
  ylim(c(1, 365))+
  xlab("Day of Year")+
  ylab("Cumulative papers")+
  ggtitle("365 papers")+
  geom_abline(slope=1, intercept=0, col="gray", lty=2)+
  theme_bw()
ggsave(file="cumulative.png")