#Chapter 16: Market Basket Analysis: Association Rules and Lift

## 16.1: Example 1: Online Radio
# Goal: Recommend new music to users from community

### *** Play Counts *** ###
lastfm[1:19,]
length(lastfm$user)  ##289,955 Records
lastfm$user <- factor(lastfm$user)
levels(lastfm$user)  ##15000 users
levels(lastfm$artist)  ##1004 artists

# Import lastfm.csv dataset
# Use R package 'arules' - mining association rules and identifying frequent item sets

## We need to manipulate the data a bit before using arules
## We need to split the data in the vector x into groups defined in vector f
## in supermarket terminology, think of users as shoppers and artists as items bought

playlist <- split(x=lastfm[,"artist"],f=lastfm$user)
# split into a list of users
playlist[1:2]
## the first two listeners (1 & 3) listen to the following bands

## an artist may be mentioned by the same user more than once
## it is important to remove artist duplicates before creating the incidents matrix

playlist <- lapply(playlist,unique)   ##Remove artist duplicates

playlist <- as(playlist,"transactions")
## View this as a list of "transactions"
## transactions is a data class defined in 'arules'

itemFrequency(playlist)
# list the support of the 1,004 bands
# number of times band is listed to on the playlist of 15,000 users
# computes relative frequency of artist mentioned by the 15,0000 users

itemFrequencyPlot(playlist,support=.08,cex.names=1.5)
# plots the item frequencies (only band with > % support)

## Finally, we build association rules
## only associations with support > 0.01 and confidence > 0.5
# this rules out rare bands

musicrules <- apriori(playlist,parameter=list(support=.01,confidence=.5))
inspect(musicrules)

## Let's filter by lift > 5
## Amoung those associations with support > 0.01 and confidence > .5
# only show those with lift > 5

inspect(subset(musicrules, subset=lift > 5))

## Lastly, order by confidence to make it easier to understand 
inspect(sort(subset(musicrules, subset=lift > 5), by="confidence"))
