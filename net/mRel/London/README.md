# London transport

## Description

Source https://manliodedomenico.com/data.php

The London transport network	
data were collected in 2013 from the official website of Transport for London ( https://www.tfl.gov.uk/) and manually cross-checked.

Nodes (369) are train stations in London and edges (441/503) encode existing routes between stations. Underground, Overground and DLR stations are considered 
(see https://www.tfl.gov.uk/ for further details). The multirelational network used in the paper makes use of three layers corresponding to:

- The aggregation to a single weighted graph of the networks of stations corresponding to each underground line (e.g., District, Circle, etc)
- The network of stations connected by Overground
- The network of stations connected by DLR

Raw data and geographical coordinates of stations are provided. The multirelational networks after considering real disruptions occurring in London are also provided.

References

1. Manlio De Domenico, Albert Solé-Ribalta, Sergio Gómez, and Alex Arenas, Navigability of interconnected networks under random failures. PNAS 111, 8351-8356 (2014)


## Conversion to Pajek NET file

```
> wdir <- "D:/vlado/data/multiRel/London_Multiplex_Transport/Dataset"
> setwd(wdir)
> source("https://raw.githubusercontent.com/bavla/Rnet/master/R/Pajek.R")
> # corrected layers file - removed (...)
> R <- read.table("london_transport_layers-C.txt",stringsAsFactors=FALSE,header=TRUE)
> L <- read.table("london_transport_multiplex.edges",header=FALSE)
> N <- read.table("london_transport_nodes.txt",stringsAsFactors=FALSE,header=TRUE)
> R
  layerID layerLabel
1       1       Tube
2       2 Overground
3       3        DLR
> head(L)
  V1 V2  V3 V4
1  1  1  77  2
2  1  1 106  1
3  1  1 219  1
4  1  1 321  2
5  1  3 224  1
6  1  3 258  1
> head(N)
  nodeID         nodeLabel  nodeLat     nodeLong
1      0         abbeyroad 51.53195  0.003737786
2      1           westham 51.52853  0.005331807
3      2      actoncentral 51.50876 -0.263415792
4      3 willesdenjunction 51.53223 -0.243894729
5      4         actontown 51.50307 -0.280288296
6      5      chiswickpark 51.49437 -0.267722520
> net <- file("London.net","w")
> n <- nrow(N)
> cat("% London",date(),"\n*vertices",n,"\n",file=net)
> for(i in 1:n) cat(i,' "',N$nodeLabel[i],'" ',N$nodeLong[i],' ',N$nodeLat[i],' 0\n',sep="",file=net)
> for(i in 1:nrow(R)) cat("*edges :",i,' "',R$layerLabel[i],'"\n',sep="",file=net)
> cat("*edges\n",file=net)
> for(i in 1:nrow(L)) cat(L$V1[i],": ",L$V2[i]," ",L$V3[i]," ",L$V4[i],"\n",sep="",file=net)
> close(net)
```
