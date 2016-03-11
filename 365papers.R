library(gsheet)
library(lubridate)
library(dplyr)
library(tidyr)
library(stringr)
library(ggplot2)

papers<-gsheet2tbl('https://docs.google.com/spreadsheets/d/1Z_4x3w2SgpOdHQ028IiPEgbB6CSFC0YT3oUymE5UoBE/edit?usp=sharing')

#add some sensible variable names
names(papers)<-c("DateTime", "Tweeter", "Content", "PaperURL", "TweetLink")
papers$DateTime<-mdy_hm(papers$DateTime) 

tidy_papers<-papers %>%
              mutate(Hour=hour(DateTime), YearDay=yday(DateTime), 
                     DOW=wday(DateTime,label=TRUE, abbr=TRUE), PaperNum=order(DateTime),
                     YearPub=as.numeric(str_extract(Content, "\\d{4}")))

#Plot diurnal distribution of tweets
ggplot(tidy_papers, aes(x=Hour))+
  geom_histogram(binwidth = 1, fill="red", col="red", alpha=0.7) +
  theme_bw()+
  ggtitle("Daily")
ggsave(file="diurnal-hist.png", width=4, height=4)

#Plot distribution by day of week
ggplot(tidy_papers, aes(x=DOW))+
  geom_bar( fill="blue", col="blue", alpha=0.7) +
  xlab("")+
  theme_bw()+
  xlab("Day of week")+
  ggtitle("Weekly")
ggsave(file="weekly-hist.png", width=4, height=4)

#Plot distribution of publication years
ggplot(tidy_papers, aes(x=YearPub))+
  geom_histogram(binwidth = 1, fill="green", col="green", alpha=0.7) +
  theme_bw()+
  xlab("Year published")+
  ggtitle("Year of publication")
ggsave(file="yearpub-hist.png", width=4, height=4)

yday_now<-yday(today())
total_papers<-max(tidy_papers$PaperNum)
right_now<-data.frame("YearDay"=yday_now, "PaperNum"=total_papers)
prog_lab<-paste0(yday_now, " days,\n", total_papers, " papers")

#Plot cumulative sum vs time
ggplot(tidy_papers, aes(x=YearDay, y=PaperNum))+
  geom_step(col="purple")+
  xlim(c(1, 100))+
  ylim(c(1, 100))+
  xlab("Day of Year")+
  ylab("Cumulative papers")+
  geom_abline(slope=1, intercept=0, col="gray", lty=2)+
	geom_point(data=right_now, aes(x=YearDay, y=PaperNum), colour="purple")+
	geom_text(data=right_now, aes(x=YearDay+2, y=PaperNum),  label=prog_lab, hjust=0, lineheight=0.7)+
  theme_bw()+
  ggtitle("Progress towards target")
ggsave(file="cumulative.png", width=4, height=4)