# Periplus

**Pajek files:** [Periplus.net](Periplus.net), [Periplus2m.clu](Periplus2m.clu)

[Dataset](https://bora.uib.no/bora-xmlui/handle/1956/11470) for network analysis extracted from the ancient Greek text known as **«The Periplus of the Erythraean Sea»**, containing lists of commodities and places (with geographical positions) mentioned in the text, and connections between them. Compiled December 2014 by Eivind Heldaas Seland, Department of archaeology, history, cultural studies and religion, University of Bergen, eivind.seland@uib.no Greek text following Frisk, H. (1927). Le Périple de la Mer Érythrée - Suivi d'une étyde sur la tradition et la langue. Göteborgs Högskolas Årsskrift,33(1), 1-145. Available also from  [subject to subscription](http://stephanus.tlg.uci.edu/inst/asearch?uid=&mode=c_search&GreekFont=Unicode_All&aname=71). English translations of commodities following Casson, Lionel. (1989)). The Periplus Maris Erythraei. Princeton:Princeton University Press. File created Feb. 9, 2016 Format: CSV (comma separated values) Columns contain id and labels for a two-mode network of ports (id 1001-) commodities (id 2001-) as well as for directed edges between them (columns labeled ‘source’ and ‘target’) and aset of nodes representing groups of commodities (2101-)

## Conversion into Pajek format

### Data cleaning
```
> wdir <- "C:/Users/vlado/DL/data/periplus"
> setwd(wdir)
> source("https://raw.githubusercontent.com/bavla/Rnet/master/R/Pajek.R")
>
> P <- read.table("Dataset.csv",sep=";",head=TRUE)
> dim(P)
[1] 1012   23
> str(P)
'data.frame':   1012 obs. of  23 variables:
 $ Id                  : int  1001 NA NA NA NA NA NA NA NA NA ...
 $ Label               : chr  "Myos Hormos" "" "" "" ...
 $ Greek               : chr  "" "" "" "" ...
 $ Nature              : chr  "Emporion" "" "" "" ...
 $ Longitude           : num  34.1 NA NA NA NA ...
 $ Latitude            : num  26.9 NA NA NA NA NA NA NA NA NA ...
 $ Source              : int  1001 1001 1001 1001 1001 1001 1001 1001 1001 1001 ...
 $ Target              : int  2032 2003 2004 2005 2003 2004 2005 2006 2007 2008 ...
 $ Port.commodity      : logi  NA NA NA NA NA NA ...
 $ Source.a            : int  1013 1018 1021 1001 1006 1006 1001 1001 1006 1008 ...
 $ Target.a            : chr  "1001" "1001" "1001" "1003" ...
 $ Type                : chr  "Undirected" "Undirected" "Undirected" "Undirected" ...
 $ port.port           : chr  "" "" "" "" ...
 $ X                   : chr  "" "" "" "" ...
 $ X.1                 : logi  NA NA NA NA NA NA ...
 $ Source.b            : int  1001 1001 1001 1001 1001 1001 1001 1001 1001 1001 ...
 $ Target.b            : int  2032 2111 2111 2111 2111 2111 2111 2111 2111 2116 ...
 $ Port.commodity.group: chr  "" "" "" "" ...
 $ Source.d            : int  2001 2002 2003 2004 2005 2006 2007 2008 2009 2010 ...
 $ Target.d            : int  2001 2002 2111 2111 2111 2111 2111 2131 2131 2118 ...
 $ Commodity.groups    : logi  NA NA NA NA NA NA ...
 $ Id.1                : int  NA 2111 2112 2113 2114 2115 2131 2117 2118 2119 ...
 $ Label.1             : chr  "" "Clothing" "Cotton-clothing" "Cloth" ...
> U <- P[P$Id %in% 1001:1999,c("Id","Label","Nature","Longitude","Latitude")]
> V <- P[P$Id %in% 2001:2999,c("Id","Label","Nature","Type","port.port","X","Port.commodity.group")]
> V1 <- P[P$Id.1 %in% 2001:2999,c("Id.1","Label.1")]

> # port-product import-export in text / directed
> R <- P[!is.na(P$Source),c("Source","Target")]
> # port-port mention in text / undirected
> Ra <- P[!is.na(P$Source.a),c("Source.a","Target.a")]
> # port-product import-export ??? / directed
> Rb <- P[!is.na(P$Source.b),c("Source.b","Target.b")]
> # product-product
> Rd <- P[!is.na(P$Source.d),c("Source.d","Target.d")]

> L <- sort(union(
+    union(union(R$Source,R$Target),union(R$Source.a,R$Target.a)),
+    union(union(R$Source.b,R$Target.b),union(R$Source.d,R$Target.d))))
> L <- sort(union(L,union(U$Id,V$Id)))
> LL <- sort(union(U$Id,V$Id))
> setdiff(L,LL)
[1] 1094 1095 2131
```
It turned out that the original data are not consistent. For example two different ports Byzantion and Toparon have the same Id.
```
788 1042;Byzantion;;;73.21;16.34;;;;;;;;;;;;;;;;;
789 1042;Toparon;;;73.22;16.22;;;;;;;;;;;;;;;;;
```
We changed the following lines in the file Dataset.csv
```
789 1058;Toparon;;;73.22;16.22;;;;;;;;;;;;;;;;;
793 1046;Bakare;;;;;;;;;;;;;;;;;;;;;
894 ;;;;;;2093;1055;;;;;;;;2115;1055;;;;;;
895 ;;;;;;2094;1055;;;;;;;;2115;1055;;;;;;
898 1056;Kammoni;;;72.58;21.16;1056;2093;;;;;;;;1056;2115;;;;;;
```
The changed data are saved in the file [DatasetCorr.csv](DatasetCorr.csv).

### Converting

```
> P <- read.table("DatasetCorr.csv",sep=";",head=TRUE)
> U <- P[P$Id %in% 1001:1999,c("Id","Label","Nature","Longitude","Latitude")]
> V <- P[P$Id %in% 2001:2999,c("Id","Label","Nature","Type","port.port","X","Port.commodity.group")]
> V1 <- P[P$Id.1 %in% 2001:2999,c("Id.1","Label.1")]
> U <- U[order(U$Id),]; V <- V[order(V$Id),]; V1 <- V1[order(V1$Id.1),]

> # place-product import-export / directed
> R <- P[!is.na(P$Source),c("Source","Target")]
> # place-place mention in text / undirected
> Ra <- P[!is.na(P$Source.a),c("Source.a","Target.a")]
> # port-product import-export ??? / directed
> Rb <- P[!is.na(P$Source.b),c("Source.b","Target.b")]
> # product-product
> Rd <- P[!is.na(P$Source.d),c("Source.d","Target.d")]

> L <- sort(union(U$Id,c(V$Id,V1$Id.1))); n <- length(L)
> nodes <- data.frame(Id=L,Name=rep("",n),Lon=rep(0,n),Lat=rep(0,n))
> I <- which(L %in% U$Id)
> nodes$Name[I] <- U$Label; nodes$Lon[I] <- U$Longitude; nodes$Lat[I] <- U$Latitude
> nodes$Name[which(L %in% V$Id)] <- V$Label
> nodes$Name[which(L %in% V1$Id.1)] <- V1$Label.1

> net <- file("Periplus.net","w",encoding="UTF-8")
> cat("% csv2Pajek",date(),"\n*vertices",n,"\n",file=net)
> v <- as.integer(factor(L,levels=L)) 
> for(i in 1:n) cat(v[i],' "',nodes$Name[i],'" ',
+   nodes$Lon[i],' ',nodes$Lat[i],' 0.5\n',sep="",file=net)
> 
> cat('*arcs :1 "places-products in text"',"\n",sep="",file=net)
> S <- as.integer(factor(R$Source,levels=L)) 
> T <- as.integer(factor(R$Target,levels=L))
> for(i in 1:length(S)) cat(S[i],T[i],1,"\n",file=net)
> 
> cat('*edges :2 "places links in text"',"\n",sep="",file=net)
> S <- as.integer(factor(Ra$Source.a,levels=L)) 
> T <- as.integer(factor(Ra$Target.a,levels=L))
> for(i in 1:length(S)) cat(S[i],T[i],1,"\n",file=net)
> 
> cat('*arcs :3 "places-products"',"\n",sep="",file=net)
> S <- as.integer(factor(Rb$Source.b,levels=L)) 
> T <- as.integer(factor(Rb$Target.b,levels=L))
> for(i in 1:length(S)) cat(S[i],T[i],1,"\n",file=net)
> 
> cat('*arcs :4 "products links"',"\n",sep="",file=net)
> S <- as.integer(factor(Rd$Source.d,levels=L)) 
> T <- as.integer(factor(Rd$Target.d,levels=L))
> for(i in 1:length(S)) cat(S[i],T[i],1,"\n",file=net)
> 
> close(net)

> b <- c("place","product")[1+(L>1999)]
> vecnom2clu(b,Clu="Periplus2m.clu")
```


```
```


```
```
