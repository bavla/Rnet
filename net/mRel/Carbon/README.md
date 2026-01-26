# Carbon Trade Network (CTN) 2000 and 2020

https://raw.githubusercontent.com/bavla/Rnet/refs/heads/master/net/mRel/Carbon/carbon.paj


Carbon Trade Networks (CTN) for years 2000 and 2020 from the paper

Guidi, G., Mastrandrea, R., Facchini, A. et al. Tracing two decades of carbon emissions using a network approach. Sci Rep 14, 7251 (2024). https://doi.org/10.1038/s41598-024-57351-0

converted into Pajek format by Vladimir Batagelj (Mon Jan 2026).
	
The multirelational social network on 112 nodes consists of 2 relations (year 2000 (1104), year 2020 (575)) between world countries.



## Conversion to Pajek project file

We converted into Pajek format the data from the [SoBigData](https://sobigdata.d4science.org/group/resourcecatalogue/data-catalogue)

* https://sobigdata.d4science.org/catalogue-sobigdata?path=/dataset/carbon_trade_network_2000
* https://sobigdata.d4science.org/catalogue-sobigdata?path=/dataset/carbon_trade_network_2020

```
> setwd("C:/Users/vlado/DL/data/SoBigData/carbon")
> CA <- read.table("Carbon2000.csv",sep=",",header=TRUE,row.names=1)
> # head(CA)
> dim(CA)
[1] 112 112
> CB <- read.table("Carbon2020.csv",sep=",",header=TRUE,row.names=1)
> dim(CB)
[1] 112 112
> # cbind(rownames(CA),rownames(CB))
> p <- order(colnames(CA))
> q <- order(colnames(CB))
> cbind(rownames(CA)[p],rownames(CB)[q])
> A <- as.matrix(CA[p,p])
> A[1:5,1:5]  
> B <- as.matrix(CB[q,q])
> B[1:5,1:5]
> source("https://raw.githubusercontent.com/bavla/Rnet/master/R/Pajek.R")
> matrix2net(A,Net="carbonA.net")
> matrix2net(B,Net="carbonB.net") 
> # ISO2 conversion using DeepSeek; Namibia -> NA
> N <- read.table("ISO3166-1alpha-2.csv",sep=";",row.names=1,na.strings = "na")
> rownames(A) <- colnames(A) <- N$V3
> matrix2net(A,Net="carbonISO2.net")
> # delete links from carbonISO2.net
```
To produce the Pajek project file we read all the created files into Pajek and save them as a project file. 

