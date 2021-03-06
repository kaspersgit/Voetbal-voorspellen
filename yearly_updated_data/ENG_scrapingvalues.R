# scraping premier league market values from transfermarkt.co.uk
library(XML)
library(RCurl)
library(httr)
library(stringr)
library(rvest)

years=as.character(2000+c(0:19))
url.names=c("Arsenal","Aston Villa","Birmingham","Blackburn","Blackpool","Bolton","Bournemouth","Bradford","Brighton","Burnley","Cardiff","Charlton","Chelsea","Coventry","Crystal Palace","Derby","Everton","Fulham","Huddersfield","Hull City","Ipswich","Leeds","Leicester","Liverpool","Man City","Man Utd","Middlesbrough","Newcastle","Norwich","Portsmouth","QPR","Reading","Sheffield Utd.","Southampton","Stoke City","Sunderland","Swansea","Spurs","Watford","West Brom","West Ham","Wigan","Wolves","Wimbledon")
team.names=c("Arsenal","Aston Villa","Birmingham","Blackburn","Blackpool","Bolton","Bournemouth","Bradford","Brighton","Burnley","Cardiff","Charlton","Chelsea","Coventry","Crystal Palace","Derby","Everton","Fulham","Huddersfield","Hull","Ipswich","Leeds","Leicester","Liverpool","Man City","Man United","Middlesbrough","Newcastle","Norwich","Portsmouth","QPR","Reading","Sheffield United","Southampton","Stoke","Sunderland","Swansea","Tottenham","Watford","West Brom","West Ham","Wigan","Wolves","Wimbledon")
AvgAge.matrix=matrix(rep(0,length(url.names)*length(years)),ncol = length(years))
AvgMV.matrix=matrix(rep(0,length(url.names)*length(years)),ncol = length(years))
TotMV.matrix=matrix(rep(0,length(url.names)*length(years)),ncol = length(years))
colnames(AvgAge.matrix)=years
rownames(AvgAge.matrix)=url.names

colnames(AvgMV.matrix)=years
rownames(AvgMV.matrix)=url.names

colnames(TotMV.matrix)=years
rownames(TotMV.matrix)=url.names

# filling the matrix with distances between te teams, skipping distance between a team and itself
for (year in years){
  # url has a simple structure with the teamnames
  weblink <- paste("https://www.transfermarkt.co.uk/premier-league/startseite/wettbewerb/GB1/plus/?saison_id=",year,sep = "" )
  # get the html text behind it
  page = GET(weblink)
  # Use rvest to extract all the tables
  tables <- rvest::html_table(content(page),fill=TRUE)
  # select table of interest 
  market.values=tables[4][[1]]
  # clean table
  market.values=market.values[-1,-1]
  colum.names=names(market.values)
  colum.names=colum.names[-3]
  market.values=market.values[,-ncol(market.values)]
  names(market.values)=colum.names
  market.values$Age=as.numeric(sub(",",".",market.values$Age))
  million_billion = vector('integer',length=nrow(market.values))
  if (!is.null(market.values$`Total Market Value`)){
    million_billion=ifelse(regmatches(market.values$`Total Market Value`,gregexpr("[a-z]+", market.values$`Total Market Value`))=='bn',1000,1)
    market.values$TMV=regmatches(market.values$`Total Market Value`, gregexpr("[[:digit:]]+[[:punct:]][[:digit:]]+", market.values$`Total Market Value`))
    market.values$TMV=as.numeric(market.values$TMV)*million_billion
    market.values$AMV=regmatches(market.values$`�-MV`, gregexpr("[[:digit:]]+[[:punct:]][[:digit:]]+", market.values$`�-MV`))
    market.values$AMV=as.numeric(market.values$AMV)
  }
    
  for (team in market.values$name){
    AvgAge.matrix[team,year]=market.values[market.values$name==team,"Age"]
    TotMV.matrix[team,year]=ifelse(is.null(market.values[market.values$name==team,"TMV"]),0,market.values[market.values$name==team,"TMV"])
    AvgMV.matrix[team,year]=ifelse(is.null(market.values[market.values$name==team,"AMV"]),0,market.values[market.values$name==team,"AMV"])

  }
}

# matching the team names as they are in other csv files 
rownames(AvgAge.matrix)=team.names
rownames(AvgMV.matrix)=team.names
rownames(TotMV.matrix)=team.names

write.csv(AvgAge.matrix,"AvgAge.csv")
write.csv(AvgMV.matrix,"AvgMV.csv")
write.csv(TotMV.matrix,"TotMV.csv")
