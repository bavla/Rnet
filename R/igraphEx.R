# igraphEx.R
# extensions to igraph
# by Vladimir Batagelj, December 2018

write.graph.paj <- function(L,file="test.paj",coor=NULL,weight="weight",ecolor="color"){
  n <- gorder(L); m <- gsize(L)
  ga <- graph_attr_names(L)
  paj <- file(file,"w")
  cat("*network test\n",file=paj)
  cat("% saved from igraph ",format(Sys.time(), "%a %b %d %X %Y"),"\n",sep="",file=paj)
  for(a in ga) cat("% ",a,": ",graph_attr(L,a),"\n",sep="",file=paj)
  cat('*vertices ',n,'\n',file=paj)
  va <- vertex_attr_names(L)
  if("name" %in% va){va <- setdiff(va,"name")
    for(v in V(L)) cat(v,' "',V(L)$name[v],'"\n',sep="",file=paj) }
  if(is_directed(L)) cat("*arcs\n",file=paj) else cat("*edges\n",file=paj)
  K <- ends(L,E(L),names=FALSE); ea <- edge_attr_names(L)
  if(weight %in% ea) w <- edge_attr(L,weight) else w <- rep(1,m)
  if(ecolor %in% ea){ C <- edge_attr(L,ecolor)
    for(e in 1:m) cat(K[e,1]," ",K[e,2]," ",w[e]," c ",as.character(C[e]),"\n",sep="",file=paj)
  } else 
    for(e in 1:m) cat(K[e,1]," ",K[e,2]," ",w[e],"\n",sep="",file=paj)
  cat("\n",file=paj)
  for(a in va){
    S <- vertex_attr(L,a); ok <- TRUE
    if(is.character(S)){
      cat("*partition ",a,"\n",sep="",file=paj)
      s <- factor(S); lev <- levels(s)
      for(i in seq_along(lev)) cat("%",i,"-",lev[i],"\n",file=paj)
    } else if(is.numeric(S)){ 
      s <- S; cat("*vector ",a,"\n",sep="",file=paj) 
    } else warning(paste("unsupported type of",a),call.=FALSE); ok <- FALSE
    if(ok){cat('*vertices ',n,'\n',file=paj)
      for(v in 1:n) cat(s[v],"\n",file=paj) }
  }
  close(paj)
}



