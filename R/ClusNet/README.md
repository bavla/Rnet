# ClusNet

```

```

```

```


```
> wdir <- "C:/Users/vlado/docs/papers/2024/Natalija/All"
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

> # https://www.sthda.com/english/wiki/beautiful-dendrogram-visualizations-in-r-5-must-known-methods-unsupervised-machine-learning
> # https://r-charts.com/color-palettes/#google_vignette
> # https://r-graph-gallery.com/31-custom-colors-in-dendrogram.html
> # https://r-charts.com/base-r/pch-symbols/

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
