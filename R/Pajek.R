#
# Pajek.R
# reading and saving of Pajek data in R (matrices and vectors)
#
# by Vladimir Batagelj, November 2019
#   May 27, 2021 - added Corrected Euclidean distance
#
# source("https://raw.githubusercontent.com/bavla/Rnet/master/R/Pajek.R")
#

clu2vector <- function(f,skip=1){
  read.table(f,skip=skip,colClasses=c("integer"),header=FALSE)$V1
}

vec2vector <- function(f,skip=1){
  read.table(f,skip=skip,colClasses=c("numeric"),header=FALSE)$V1
}

net2matrix <- function(f){
# reads a network from Pajek's net file; skips initial comments lines
   L <- readLines(f)
   st <- grep("\\*",L)
   S <- unlist(strsplit(trimws(L[st[1]]),'[[:space:]]+'))
   ls <- length(S); twomode <- ls > 2
   if(twomode){nr <- as.integer(S[3]); nc <- as.integer(S[2])-nr} else
     {nr <- nc <- as.integer(S[2])}
   n <- as.integer(S[2]); n1 <- st[1]+1; n2 <- st[2]-1
   m1 <- st[2]+1; m2 <- length(L); m <- m2-m1+1
   Q <- strsplit(L[n1:n2],'"'); Nam <- c()
   for(e in Q) Nam <- c(Nam,e[2])
   if(twomode){rNam <- Nam[1:nr]; cNam <- Nam[(nr+1):n]
   } else {rNam <- cNam <- Nam[1:nr]}
   R <- matrix(data=0,nrow=nr,ncol=nc,dimnames=list(rNam,cNam))
   S <- unlist(strsplit(trimws(L[m1:m2]),'[[:space:]]+'))
   b <- as.integer(S[3*(1:m)-2]); e <- as.integer(S[3*(1:m)-1]); v <- as.numeric(S[3*(1:m)])
   if(twomode) e <- e - nr
   for(k in 1:m) R[b[k],e[k]] <- R[b[k],e[k]]+v[k]
   return(R)
}

matrix2net <- function(M,Net="Pajek.net"){
  n <- nrow(M); net <- file(Net,"w")
  cat("% mat2Pajek",date(),"\n*vertices",n,"\n",file=net)
  RN <- row.names(M)
  for(v in 1:n) cat(v,' "',RN[v],'"\n',sep="",file=net)
  cat("*arcs\n",file=net)
  for(v in 1:n) for(u in 1:n) if(M[v,u]!=0) cat(v,u,M[v,u],"\n",file=net)
  close(net)
}

bimatrix2net <- function(M,Net="Pajek.net"){
  n <- nrow(M); m <- ncol(M); net <- file(Net,"w")
  cat("% bip2Pajek",date(),"\n*vertices",n+m,n,"\n",file=net)
  RN <- dimnames(M)[[1]]; CN <- dimnames(M)[[2]];
  for(v in 1:n) cat(v,' "',RN[v],'"\n',sep="",file=net)
  for(u in 1:m) cat(u+n,' "',CN[u],'"\n',sep="",file=net)
  cat("*arcs\n",file=net)
  for(v in 1:n) for(u in 1:m) if(M[v,u]!=0) cat(v,u+n,M[v,u],"\n",file=net)
  close(net)
}

uv2net <- function(u,v,w=NULL,Net="Pajek.net",twomode=FALSE){
  net <- file(Net,"w")
  if(is.null(w)) w <- rep(1,length(u))
  RN <- levels(u); n <- length(RN)
  if(twomode) {CN <- levels(v);  m <- length(CN)}
  U <- as.integer(u); V <- as.integer(v)
  if(twomode) cat("% uv2Pajek",date(),"\n*vertices",n+m,n,"\n",file=net) else
    cat("% uv2Pajek",date(),"\n*vertices",n,"\n",file=net)
  for(i in 1:n) cat(i,' "',RN[i],'"\n',sep="",file=net)
  if(twomode) for(i in 1:m) cat(i+n,' "',CN[i],'"\n',sep="",file=net)
  cat("*arcs\n",file=net)
  for(i in 1:length(u)) cat(U[i],V[i]+twomode*n,w[i],"\n",file=net)
  close(net)
}

vector2clu <- function(C,Clu="Pajek.clu"){
  n <- length(C); clu <- file(Clu,"w")
  cat("% clu2Pajek",date(),"\n*vertices",n,"\n",file=clu)
  cat(C,sep="\n",file=clu)
  close(clu)
}

vector2vec <- function(X,Vec="Pajek.vec"){
  n <- length(X); vec <- file(Vec,"w")
  cat("% vec2Pajek",date(),"\n*vertices",n,"\n",file=vec)
  cat(X,sep="\n",file=vec)
  close(vec)
}

# Corrected Euclidean distance
CorEu <- function(W,p=1){
  D <- W; diag(D) <- 0; n = nrow(D)
  for(u in 1:(n-1)) for(v in (u+1):n) D[v,u] <- D[u,v] <- 
    sqrt(sum((W[u,]-W[v,])**2) -
      (W[u,u]-W[u,v])**2 - (W[v,u]-W[v,v])**2 +
      p*((W[u,u]-W[v,v])**2 + (W[u,v]-W[v,u])**2)) 
  return(D)
}
