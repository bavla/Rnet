# Eu-Air transportation

## Description

Source file
- https://manliodedomenico.com/data.php

The multirelational network on 450 nodes and 3588 edges is composed of 37 relations each one corresponding to an airline company operating in Europe.

References
1. Alessio Cardillo, Jesús Gómez-Gardenes, Massimiliano Zanin, Miguel Romance, David Papo, Francisco del Pozo and Stefano Boccaletti - Emergence of network features from multiplexity. Scientific Reports 3, Article number: 1344 doi:10.1038/srep01344 ; https://www.nature.com/articles/srep01344

See the official web page http://complex.unizar.es/~atnmultiplex/ for further details.

## Conversion to Pajek NET file

```
> wdir <- "D:/vlado/data/multiRel/EUAir_Multiplex_Transport/Dataset"
> setwd(wdir)
> source("https://raw.githubusercontent.com/bavla/Rnet/master/R/Pajek.R")
> R <- read.table("EUAirTransportation_layers.txt",stringsAsFactors=FALSE,header=TRUE)
> L <- read.table("EUAirTransportation_multiplex.edges",header=FALSE)
> N <- read.table("EUAirTransportation_nodes.txt",stringsAsFactors=FALSE,header=TRUE)
> head(R)
  nodeID        nodeLabel
1      1        Lufthansa
2      2          Ryanair
3      3          Easyjet
4      4  British_Airways
5      5 Turkish_Airlines
6      6       Air_Berlin
> head(L)
  V1 V2 V3 V4
1  1  1  2  1
2  1  1 38  1
3  1  2  7  1
4  1  2  8  1
5  1  2 10  1
6  1  2 14  1
> head(N)
  nodeID nodeLabel  nodeLong  nodeLat
1      1      LCLK 33.630278 34.87889
2      2      EDDF  8.570555 50.03333
3      3      EDDK  7.142779 50.86583
4      4      EGNX -1.328055 52.83111
5      5      EGTE -3.413888 50.73444
6      6      LTBJ 27.155001 38.28917
> net <- file("EUAir.net","w")
> n <- nrow(N)
> cat("% EUAir",date(),"\n*vertices",n,"\n",file=net)
> for(i in 1:n) cat(i,' "',N$nodeLabel[i],'" ',N$nodeLong[i],' ',N$nodeLat[i],' 0\n',sep="",file=net)
> for(i in 1:nrow(R)) cat("*edges :",i,' "',R$nodeLabel[i],'"\n',sep="",file=net)
> cat("*edges\n",file=net)
> for(i in 1:nrow(L)) cat(L$V1[i],": ",L$V2[i]," ",L$V3[i]," ",L$V4[i],"\n",sep="",file=net)
> close(net)
```
