# This file contains some additional functions used in igraph examples
# for the Network analysis course at HSE Moscow in November 2017 and
# December 2018 by Vladimir Batagelj

empty <- character(0)

normalize <- function(x,marg=0) return ((1-2*marg)*(x-min(x))/(max(x)-min(x))+marg)

write.graph.paj <- function(N,file="test.paj",vname="name",coor=NULL,va=NULL,ea=NULL,
  weight="weight",ecolor="color"){
  n <- gorder(N); m <- gsize(N); ga <- graph_attr_names(N)
  if(is.null(va)) va <- vertex_attr_names(N)
  if(is.null(ea)) ea <- edge_attr_names(N)
  va <- union(va,vname); ea <- union(ea,weight)
  paj <- file(file,"w")
  cat("*network",file,"\n",file=paj)
  cat("% saved from igraph ",format(Sys.time(), "%a %b %d %X %Y"),"\n",sep="",file=paj)
  for(a in ga) cat("% ",a,": ",graph_attr(N,a),"\n",sep="",file=paj)
  cat('*vertices ',n,'\n',file=paj)
  lab <- if(vname %in% va) vertex_attr(N,vname) else paste("v",1:n,sep="") 
  if(is.null(coor)){  
    if(vname %in% va) for(v in V(N)) cat(v,' "',lab[v],'"\n',sep="",file=paj)
  } else { 
    for(v in V(N)) cat(v,' "',lab[v],'" ',paste(coor[v,],collapse=" "),'\n',sep="",file=paj) 
  }
  va <- setdiff(va,vname)
  cat(ifelse(is_directed(N),"*arcs\n","*edges\n"),file=paj)
  K <- ends(N,E(N),names=FALSE) 
  w <- if(weight %in% ea) edge_attr(N,weight) else rep(1,m)
  if(ecolor %in% ea){ C <- edge_attr(N,ecolor)
    for(e in 1:m) cat(K[e,1]," ",K[e,2]," ",w[e]," c ",as.character(C[e]),"\n",sep="",file=paj)
  } else 
    for(e in 1:m) cat(K[e,1]," ",K[e,2]," ",w[e],"\n",sep="",file=paj)
  ea <- setdiff(ea,c(weight,ecolor)); nr <- 1
  for(a in ea){nr <- nr+1; w <- edge_attr(N,a)
    cat(ifelse(is_directed(N),"*arcs","*edges"),file=paj)
    cat(" :",nr,' "',a,'"\n',sep="",file=paj)
    if(is.numeric(w)){
      for(e in 1:m) cat(K[e,1]," ",K[e,2]," ",w[e],"\n",sep="",file=paj)
    } else if(is.character(w)){ 
      W <- factor(w); lev <- levels(W)
      for(i in seq_along(lev)) cat("%",i,"-",lev[i],"\n",file=paj)
      for(e in 1:m) cat(K[e,1]," ",K[e,2]," ",W[e],' l "',w[e],'"\n',sep="",file=paj)
    } else warning(paste("unsupported type of",a),call.=FALSE)
  }
  cat("\n",file=paj)
  for(a in va){
    S <- vertex_attr(N,a); ok <- TRUE
    if(is.character(S)){
      cat("*partition ",a,"\n",sep="",file=paj)
      s <- factor(S); lev <- levels(s)
      for(i in seq_along(lev)) cat("%",i,"-",lev[i],"\n",file=paj)
    } else if(is.numeric(S)){ 
      s <- S; cat("*vector ",a,"\n",sep="",file=paj) 
    } else {warning(paste("unsupported type of",a),call.=FALSE); ok <- FALSE}
    if(ok){cat('*vertices ',n,'\n',file=paj)
      for(v in 1:n) cat(s[v],"\n",file=paj)
      cat("\n",file=paj) }
  }
  close(paj)
}

# source("https://raw.githubusercontent.com/bavla/Rnet/master/R/igraph+.R")

# https://lists.nongnu.org/archive/html/igraph-help/2013-07/msg00085.html
graph.reverse <- function (graph) {
  if (!is.directed(graph))
    return(graph)
  e <- get.data.frame(graph, what="edges")
  ## swap "from" & "to"
  neworder <- 1:length(e)
  neworder[1:2] <- c(2,1)
  e <- e[neworder]
  names(e) <- names(e)[neworder]
  graph.data.frame(e, vertices = get.data.frame(graph, what="vertices"))
}

top <- function(v,k){
  ord <- rev(order(v)); sel <- ord[1:k]
  S <- data.frame(name=names(v[sel]),value=as.vector(v[sel]))
  return(S)
}

read_Pajek_clu <- function(f,skip=1){
  read.table(f,skip=skip,colClasses=c("integer"),header=FALSE)$V1
}

read_Pajek_vec <- function(f,skip=1){
  read.table(f,skip=skip,colClasses=c("numeric"),header=FALSE)$V1
}

extract_clusters <- function(N,atn,clus){
  C <- vertex_attr(N,atn); S <- V(N)[C %in% clus]
  return(induced_subgraph(N,S))
}

vertex_cut <- function(N,atn,t){
  v <- vertex_attr(N,atn); vCut <- V(N)[v>=t] 
  return(induced_subgraph(N,vCut))
}

edge_cut <- function(N,atn,t){
  w <- edge_attr(N,atn); eCut <- E(N)[w>=t] 
  return(subgraph.edges(N,eCut))
}



