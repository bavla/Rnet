# Lazega Law Firm

The data are available for example at
- https://manliodedomenico.com/data.php
- https://www.stats.ox.ac.uk/~snijders/siena/Lazega_lawyers_data.htm

## Conversion to Pajek project file

We converted into Pajek format the data from the first source.
```
> # Lazega-Law-Firm
>
> wdir <- "D:/vlado/data/multiRel/Lazega-Law-Firm_Multiplex_Social/Dataset"
> setwd(wdir)
> source("https://raw.githubusercontent.com/bavla/Rnet/master/R/Pajek.R")
> R <- read.table("Lazega-Law-Firm_layers.txt",stringsAsFactors=FALSE,header=TRUE)
> R
  layerID layerLabel
1       1     advice
2       2 friendship
3       3    co-work
> L <- read.table("Lazega-Law-Firm_multiplex.edges",header=FALSE)
> dim(L)
[1] 2571    4
> head(L)
  V1 V2 V3 V4
1  1  1  2  1
2  1  1 17  1
3  1  1 20  1
4  1  2  1  1
5  1  2  6  1
6  1  2 17  1
> N <- read.table("Lazega-Law-Firm_nodes.txt",stringsAsFactors=FALSE,header=TRUE)
> dim(N)
[1] 71  8
> head(N)
  nodeID nodeStatus nodeGender nodeOffice nodeSeniority nodeAge nodePractice nodeLawSchool
1      1          1          1          1            31      64            1             1
2      2          1          1          1            32      62            2             1
3      3          1          1          2            13      67            1             1
4      4          1          1          1            31      59            2             3
5      5          1          1          2            31      59            1             2
6      6          1          1          2            29      55            1             1
>
> net <- file("Lazega.net","w")
> n <- nrow(N)
> NR <- paste("L",1:n,sep="")
> cat("% Lazega Law Firm",date(),"\n*vertices",n,"\n",file=net)
> for(i in 1:n) cat(i,' "',NR[i],'"\n',sep="",file=net)
> for(i in 1:nrow(R)) cat("*arcs :",i,' "',R$layerLabel[i],'"\n',sep="",file=net)
> cat("*arcs\n",file=net)
> for(i in 1:nrow(L)) cat(L$V1[i],": ",L$V2[i]," ",L$V3[i]," ",L$V4[i],"\n",sep="",file=net)
> close(net)
> vector2clu(N$nodeStatus,Clu="status.clu")
> vector2clu(N$nodeGender,Clu="gender.clu")
> vector2clu(N$nodeOffice,Clu="office.clu")
> vector2vec(N$nodeSeniority,Vec="seniority.vec")
> vector2vec(N$nodeAge,Vec="age.vec")
> vector2clu(N$nodePractice,Clu="practice.clu")
> vector2clu(N$nodeLawSchool,Clu="lawSchool.clu")
```
To produce the Pajek project file we read all the created files into Pajek and save them as a project file. Finally we add some metadata using a text editor.

