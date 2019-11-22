




read_Pajek_clu <- function(f,skip=1){
  read.table(f,skip=skip,colClasses=c("integer"),header=FALSE)$V1
}

read_Pajek_vec <- function(f,skip=1){
  read.table(f,skip=skip,colClasses=c("numeric"),header=FALSE)$V1
}

mat2Pajek <- function(M,Net="Pajek.net"){
  n <- nrow(M); net <- file(Net,"w")
  cat("% mat2Pajek",date(),"\n*vertices",n,"\n",file=net)
  RN <- row.names(M)
  for(v in 1:n) cat(v,' "',RN[v],'"\n',sep="",file=net)
  cat("*arcs\n",file=net)
  for(v in 1:n) for(u in 1:n) if(M[v,u]!=0) cat(v,u,M[v,u],"\n",file=net)
  close(net)
}

bip2Pajek <- function(M,Net="Pajek.net"){
  n <- nrow(M); m <- ncol(M); net <- file(Net,"w")
  cat("% bip2Pajek",date(),"\n*vertices",n+m,n,"\n",file=net)
  RN <- dimnames(M)[[1]]; CN <- dimnames(M)[[2]];
  for(v in 1:n) cat(v,' "',RN[v],'"\n',sep="",file=net)
  for(u in 1:m) cat(u+n,' "',CN[u],'"\n',sep="",file=net)
  cat("*arcs\n",file=net)
  for(v in 1:n) for(u in 1:m) if(M[v,u]!=0) cat(v,u+n,M[v,u],"\n",file=net)
  close(net)
}

clu2Pajek <- function(C,Clu="Pajek.clu"){
  n <- length(C); clu <- file(Clu,"w")
  cat("% clu2Pajek",date(),"\n*vertices",n,"\n",file=clu)
  cat(C,sep="\n",file=clu)
  close(clu)
}

vec2Pajek <- function(X,Vec="Pajek.vec"){
  n <- length(X); vec <- file(Vec,"w")
  cat("% vec2Pajek",date(),"\n*vertices",n,"\n",file=vec)
  cat(X,sep="\n",file=vec)
  close(vec)
}
