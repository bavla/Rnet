# Ps cores visualizations
March 27-30, 2025

## Ps cores data

The data are prepared in the file `ct Ps cores.csv`
```
 rank  , Id , reg, loc, Clu, Value 
   1  , "Ted Enamorado"                   , 3 , 3 , 35   , 36.666666666
   2  , "Gabriel L&#243;pez-Moctezuma"    , 3 , 3 , 35   , 36.666666666
   3  , "Marc Ratkovic"                   , 3 , 3 , 35   , 36.666666666
   4  , "Aaron D. Ames"                   , 3 , 2 , 7    , 26.165980584
   5  , "Lior Pachter"                    , 3 , 3 , 6    , 22.269776227
   6  , "Chi Ma"                          , 3 , 3 , 23   , 21
   7  , "Alan E. Rubin"                   , 3 , 3 , 23   , 21
   8  , "P. P. Vaidyanathan"              , 3 , 3 , 20   , 21
   9  , "C. Elachi"                       , 2 , 1 , 5    , 18.080555556
  10  , "Jakob van Zyl"                   , 3 , 2 , 5    , 18
...
 108  , "Renyu Hu"                        , 3 , 2 , 12   , 3.207326663
 109  , "Mario Damiano"                   , 9 , 1 , 12   , 3.207326663
 110  , "Shu-Heng Shao"                   , 6 , 1 , 13   , 3.205555556
```

## Creating a Ps cores dendrogram

These data can be transformed into clustering dendrogram using the function
```
coreCompDendro <- function(lab,core,C){
  n <- length(lab); J <- rep(0,n); j <- 0; D <- 0
  clu <- list(merge=matrix(0,nrow=n-1,ncol=2),height=rep(0,n-1),
    order=1:n,labels=lab,method="coreDendro",call=NULL,
    dist.method="core level")
  attr(clu,"class") <- "hclust"
  i <- 0; h <- core[1]; d <- 1; v <- -1; g <- C[1] 
  for(u in 2:n){
    if(g!=C[u]){j <- j+1; J[j] <- v; g <- C[u];
      h <- core[u]; d <- 1; v <- -u
    } else {i <- i+1
      clu$merge[i,1] <- v; clu$merge[i,2] <- -u
      if(core[u]>h) {h <- core[u]; d <- d+1; D <- max(D,d)}
      clu$value[i] <- core[u]; v <- i; clu$height[i] <- d
    }
  }
  M <- max(core)*1.2; D <- D*1.2; i <- i+1
  clu$merge[i,1] <- v; clu$merge[i,2] <- J[j]; j <- j-1
  clu$value[i] <- M; clu$height[i] <- D
  for(k in (i+1):(n-1)){
    clu$merge[k,1] <- J[j]; j <- j-1; clu$merge[k,2] <- k-1
    clu$value[k] <- M; clu$height[k] <- D
  }
  return(clu)
}
```
The function `coreCompDendro` is available in the package [ClusNet.R](../ClusNet.R).

## Example Caltech

The data are in Pajek files.
Non ASCII characters in names are represented as XML entities such as &#243;. We use library xml2 to convert them into Unicode.

Another problem is the ordering of Ps cores.

Some hints for enhacing the dendrogram can be found in
  * [Beautiful dendrogram visualizations in R](https://www.sthda.com/english/wiki/beautiful-dendrogram-visualizations-in-r-5-must-known-methods-unsupervised-machine-learning)
  * [Color palettes](https://r-charts.com/color-palettes/#google_vignette)
  * [Dendrogram with color and legend in R](https://r-graph-gallery.com/31-custom-colors-in-dendrogram.html)
  * [R pch symbols](https://r-charts.com/base-r/pch-symbols/)


```
> wdir <- "C:/2024/Natalija/All"
> setwd(wdir)
> library(xml2)
> library(dendextend)
> library(paletteer)
> library(svglite)
> Rnet <- "https://raw.githubusercontent.com/bavla/Rnet/master/R/"
> source(paste0(Rnet,"ClusNet.R"))
> Ps <- read.csv("ct Ps cores.csv",strip.white=TRUE)
> S <- as_list(read_html(paste0("<html>",paste(Ps$Id,collapse=","),"</html>")))$html$body$p[[1]]
> Ps$Id <- strsplit(S,",")[[1]]

> vMin <- Pp %>% group_by(Clu) %>% summarise(vMin=min(Value,na.rm=TRUE))
> V <- as.data.frame(vMin); q<-order(V$vMin,decreasing=TRUE)
> s <- 1:35; s[q] <- 1:35; K <- s[Ps$Clu]
> # I <- 1000*Ps$Clu-Ps$rank
> I <- 1000*K-Ps$rank; p <- order(I); Pp <- Ps[p,]

> cp <- coreCompDendro(Pp$Id,Pp$Value,Pp$Clu)
> plot(cp,main="ct Ps cores",cex=0.6)

> hp <- cp$height
> cp$height <- cp$value
> plot(cp,main="ct Ps cores",cex=0.6)

> dend <- as.dendrogram(cp)
> col <- paletteer_d("ggthemes::few_Dark")
> shape <- c(17, 15, 16)
> dend %>% set("labels_cex",0.6) %>% 
+   set("labels_col",col[Pp$reg]) %>% 
+   set("hang_leaves",0.05) %>% 
+   set("leaves_pch", shape[Pp$loc] ) %>% 
+   set("leaves_cex", 1) %>%  
+   set("leaves_col", col[Pp$reg]) %>% 
+   plot(main="ct Ps cores")
> 
> Reg <- c("East and Southeast Asia", "Europe", "North America", "South Asia",
+   "Australia and Oceania", "South America", "Middle East", "Central Asia", "QQ")
> legend("topright", 
+      legend = Reg, col = col, 
+      pch = rep(20,9), bty = "n",  pt.cex = 1.5, cex = 0.8 , 
+      text.col = "black", horiz = FALSE, inset = c(0, 0.1))
```


```
> svglite("ctPsCores.svg",width=16,height=8)
> dend %>% set("labels_cex",0.6) %>% 
+   set("labels_col",col[Pp$reg]) %>% 
+   set("hang_leaves",0.05) %>% 
+   set("leaves_pch", shape[Pp$loc] ) %>% 
+   set("leaves_cex", 1) %>%  
+   set("leaves_col", col[Pp$reg]) %>% 
+   plot(main="ct Ps cores") 
> Reg <- c("East and Southeast Asia", "Europe", "North America", "South Asia",
+   "Australia and Oceania", "South America", "Middle East", "Central Asia", "QQ")
> legend("topright", 
+      legend = Reg, col = col, 
+      pch = rep(20,9), bty = "n",  pt.cex = 1.5, cex = 0.8 , 
+      text.col = "black", horiz = FALSE, inset = c(0, 0.1))
> dev.off()
```

```

```
