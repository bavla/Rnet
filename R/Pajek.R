#
# Pajek.R
# reading and saving of Pajek data in R (matrices and vectors)
#
# by Vladimir Batagelj, November 2019
#   May 27, 2021 - added Corrected Euclidean distance
#   Aug 30, 2021 - added RC2dendro, orDendro, orSize, derivedTree, varCutree
#   Jan 22, 2022 - net2matrix knows *matrix
#                  uvLab2net saves lists to Pajek
#   Nov  1, 2022 - uvFac2net extended with multi-relations r and time points t
#   Nov  4, 2022 - uvrwt2net a version of uvFac2net with internal factorization
#   Aug 10, 2023 - uvLab2net extended with time
#   Nov 26, 2023 - uvrwt2net extended with directed and time intervals
#   Feb  7, 2024 - vecnom2clu nominal variable to partition with legend
#
# source("https://raw.githubusercontent.com/bavla/Rnet/master/R/Pajek.R")
#


clu2vector <- function(f,skip=1){
  read.table(f,skip=skip,colClasses=c("integer"),header=FALSE)$V1
}

vec2vector <- function(f,skip=1){
  read.table(f,skip=skip,colClasses=c("numeric"),header=FALSE)$V1
}

net2matrix <- function(f,warn=1){
# reads a network from Pajek's net file; skips initial comments lines
# set warn=-1 to suppress warnings
   defaultW <- getOption("warn"); options(warn=warn)
   L <- tryCatch(readLines(f,warn=FALSE),
     error=function(cond) {if(warn>0) message(cond); return(NA)},
     warning=function(cond) {if(warn>0) message(cond); return(NA)},
     finally={} )    
#   L <- readLines(f)
   options(warn = defaultW)
   if(is.na(L[1])) return(NA)
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
   repr <- substr(tolower(L[n2+1]),1,5)
   if(repr=="*matr"){library(tseries)
     R <- as.matrix(read.matrix(page,skip=n2+1))
     dimnames(R) <- list(rNam,cNam)
   } else {
     R <- matrix(data=0,nrow=nr,ncol=nc,dimnames=list(rNam,cNam))
     S <- unlist(strsplit(trimws(L[m1:m2]),'[[:space:]]+'))
     b <- as.integer(S[3*(1:m)-2]); e <- as.integer(S[3*(1:m)-1]); v <- as.numeric(S[3*(1:m)])
     if(twomode) e <- e - nr
     for(k in 1:m) R[b[k],e[k]] <- R[b[k],e[k]]+v[k]
   }
   return(R)
}

matrix2net <- function(M,Net="Pajek.net",encoding="UTF-8"){
  n <- nrow(M); net <- file(Net,"w",encoding=encoding)
  if(encoding=="UTF-8") cat('\xEF\xBB\xBF',file=net)
  cat("% mat2Pajek",date(),"\n*vertices",n,"\n",file=net)
  RN <- row.names(M)
  for(v in 1:n) cat(v,' "',RN[v],'"\n',sep="",file=net)
  cat("*arcs\n",file=net)
  for(v in 1:n) for(u in 1:n) if(M[v,u]!=0) cat(v,u,M[v,u],"\n",file=net)
  close(net)
}

bimatrix2net <- function(M,Net="Pajek.net",encoding="UTF-8"){
  n <- nrow(M); m <- ncol(M); net <- file(Net,"w",encoding=encoding)
  if(encoding=="UTF-8") cat('\xEF\xBB\xBF',file=net)
  cat("% bip2Pajek",date(),"\n*vertices",n+m,n,"\n",file=net)
  RN <- dimnames(M)[[1]]; CN <- dimnames(M)[[2]];
  for(v in 1:n) cat(v,' "',RN[v],'"\n',sep="",file=net)
  for(u in 1:m) cat(u+n,' "',CN[u],'"\n',sep="",file=net)
  cat("*arcs\n",file=net)
  for(v in 1:n) for(u in 1:m) if(M[v,u]!=0) cat(v,u+n,M[v,u],"\n",file=net)
  close(net)
}

uvFac2net <- function(u,v,w=NULL,r=NULL,t=NULL,Net="Pajek.net",twomode=FALSE,encoding="UTF-8"){
  net <- file(Net,"w",encoding=encoding)
  if(encoding=="UTF-8") cat('\xEF\xBB\xBF',file=net)
  if(is.null(w)) w <- rep(1,length(u))
  RN <- levels(u); n <- length(RN)
  if(twomode) {CN <- levels(v);  m <- length(CN)}
  U <- as.integer(u); V <- as.integer(v)
  if(twomode) cat("% uvFac2Pajek",date(),"\n*vertices",n+m,n,"\n",file=net) else
    cat("% uvFac2Pajek",date(),"\n*vertices",n,"\n",file=net)
  for(i in 1:n) cat(i,' "',RN[i],'"\n',sep="",file=net)
  if(twomode) for(i in 1:m) cat(i+n,' "',CN[i],'"\n',sep="",file=net)
  if(!is.null(r)){R <- as.integer(r); N <- levels(r)
    for(i in 1:length(N)) cat("*arcs :",i,' "',N[i],'"\n',sep="",file=net)}
  cat("*arcs\n",file=net)
  for(i in 1:length(u)) cat(ifelse(is.null(r),"",paste(R[i],": ",sep="")),
    U[i],V[i]+twomode*n,w[i],
    ifelse(is.null(t),"",paste(" [",t[i],"]",sep="")),"\n",file=net)
  close(net)
}

uvrwt2net <- function(u,v,w=NULL,r=NULL,t=NULL,Net="Pajek.net",
  twomode=FALSE,directed=TRUE,encoding="UTF-8"){
  tint <- function(sf,i){ts <- as.integer(sf[i,1]); tf <- as.integer(sf[i,2])
    ifelse(ts==tf,ts,paste(ts,"-",tf,sep=""))}
  net <- file(Net,"w",encoding=encoding)
  if(encoding=="UTF-8") cat('\xEF\xBB\xBF',file=net)
  if(is.null(w)) w <- rep(1,length(u))
  if(twomode) {u <- factor(u); v <- factor(v); RN <- levels(u);
    CN <- levels(v);  m <- length(CN)} else
  {RN <- levels(factor(c(u,v))); u <- factor(u,levels=RN); v <- factor(v,levels=RN) }
  n <- length(RN); links <- ifelse(directed,"*arcs","*edges")
  U <- as.integer(u); V <- as.integer(v)
  if(twomode) cat("% uvrwt2Pajek",date(),"\n*vertices",n+m,n,"\n",file=net) else
    cat("% uvrwt2Pajek",date(),"\n*vertices",n,"\n",file=net)
  for(i in 1:n) cat(i,' "',RN[i],'"\n',sep="",file=net)
  if(twomode) for(i in 1:m) cat(i+n,' "',CN[i],'"\n',sep="",file=net)
  if(!is.null(r)){r <- factor(r); RR <- levels(r)
    for(i in 1:length(RR)) cat(links," :",i,' "',RR[i],'"\n',sep="",file=net)
  }
  cat(links,"\n",sep="",file=net)
  for(i in 1:length(u)) cat(ifelse(is.null(r),"",paste(as.integer(r)[i],": ",sep="")),
    U[i],V[i]+twomode*n,w[i],
    ifelse(is.null(t),"",paste(" [",tint(t,i),"]",sep="")),"\n",file=net)
  close(net)
}

uvLab2net <- function(Lab,U,V,W,t=NULL,Net="Pajek.net",dir=FALSE,encoding="UTF-8"){
  net <- file(Net,"w",encoding=encoding)
  if(encoding=="UTF-8") cat('\xEF\xBB\xBF',file=net)
  n <- length(Lab); m <- length(U); time <- !is.null(t)
  if(time){tmin <- min(t); tmax <- max(t); tin <- paste('" [',tmin,"-",tmax,"]",sep="")}
  cat("% uvLab2net",date(),"\n*vertices",n,"\n",file=net)
  for(v in 1:n) cat(v,' "',Lab[v],ifelse(time,tin,'"'),'\n',sep="",file=net)
  cat(ifelse(dir,"*arcs\n","*edges\n"),file=net)
  for(e in 1:m) cat(U[e],V[e],W[e],ifelse(time,paste(" [",t[e],"]"),""),"\n",file=net)
  close(net)
} 

vector2clu <- function(C,Clu="Pajek.clu"){
  n <- length(C); clu <- file(Clu,"w")
  cat("% clu2Pajek",date(),"\n*vertices",n,"\n",file=clu)
  cat(C,sep="\n",file=clu)
  close(clu)
}

vecnom2clu <- function(N,Clu="Pajek.clu",na=0,encoding="UTF-8"){
  n <- length(N); clu <- file(Clu,"w",encoding=encoding)
  if(encoding=="UTF-8") cat('\xEF\xBB\xBF',file=clu)
  C <- factor(N); L <- levels(C);  C <- as.integer(C); C[is.na(C)] <- na 
  cat("% nom2Pajek",date(),"\n%",
    paste(1:length(L),": ",L,collapse="; ",sep=""),
    "\n*vertices",n,"\n",file=clu)
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
      (W[u,u]-W[v,u])**2 - (W[u,v]-W[v,v])**2 +
      p*((W[u,u]-W[v,v])**2 + (W[u,v]-W[v,u])**2)) 
  return(D)
}

RC2dendro <- function(cling){
  tree <- as.integer(read.csv(cling,header=FALSE,skip=1)$V1)
  N <- length(tree); n <- (N+1) %/% 2
  merge <- matrix(0,nrow=(n-1),ncol=2)
  for(i in 1:n) if(tree[i]>0){
    k <- tree[i]-n
    if(merge[k,1]==0) merge[k,1] <- -i else merge[k,2] <- -i
  }
  for(i in (n+1):N) if(tree[i]>0){
    k <- tree[i]-n; j <- i-n
    if(merge[k,1]==0) merge[k,1] <- j else merge[k,2] <- j
  }
  return(list(merge=merge,n=n))
}
 
orDendro <- function(m,i){if(i<0) return(-i)
  return(c(orDendro(m,m[i,1]),orDendro(m,m[i,2])))}

orSize <- function(m,i){if(i<0) return(1)
  s[i] <<- orSize(m,m[i,1])+orSize(m,m[i,2])
  return(s[i])}

derivedTree <- function(R,type='rank'){
  if (type == 'total') { c <- 0; ex <- expression(a+b+R$height[i]) }
  else if (type == 'count') { c <- 1; ex <- expression(a+b) }
  else  { c <- 0; ex <- expression(1+max(a,b)) }
  nm <- length(R$height)
  h <- rep(c,nm)
  for (i in 1:nm){
    j <- R$merge[i,1]; a <- ifelse(j<0,c,h[j])
    j <- R$merge[i,2]; b <- ifelse(j<0,c,h[j])
    h[i] <- eval(ex)
  }
  return(h)
}

varCutree <- function(R,var,vmin,vmax){
  mark <- function(t,c){
    if(t<0) part[-t] <<- c else {mark(R$merge[t,1],c); mark(R$merge[t,2],c)}
  }
  n <- length(var); part <- rep(999999,n); nclust <- 0
  value <- cbind(var,rep(0,n))
  for(i in 1:(n-1)){
    j <- R$merge[i,1]; if(j==0) next 
    a <- ifelse(j<0,value[-j,1],value[j,2])
    j <- R$merge[i,2]; if(j==0) next 
    b <- ifelse(j<0,value[-j,1],value[j,2])
    value[i,2] <- a+b
  }
  value[n,2] <- 0
  for(i in 1:(n-1)){
    if(value[i,2]<=vmax) next
    l <- R$merge[i,1]; r <- R$merge[i,2] 
    if(l==0) a <- 0 else a <- ifelse(l<0,value[-l,1],value[l,2])
    if(r==0) b <- 0 else b <- ifelse(r<0,value[-r,1],value[r,2])
    if(min(a,b)>vmax) next
    if(a<=vmax) if(a>=vmin) {nclust <- nclust+1; mark(l,nclust)} else mark(l,0)
    if(b<=vmax) if(b>=vmin) {nclust <- nclust+1; mark(r,nclust)} else mark(r,0)    
  }  
  return(list(part=part,value=value))
}

sp2Pajek <- function(sp,file="neighbors.net",name=0,queen=TRUE,BOM=TRUE){
  library(spdep)
  nbs <- poly2nb(sp,queen=queen)
  n <- length(nbs); L <- card(nbs)
  xy <- coordinates(sp)
  IDs <- as.character(if(name>0) sp[[name]] else 1:n)
  net <- file(file,"w")
  if(BOM) writeChar("\ufeff",net,eos=NULL) 
  cat("% sp2Pajek:",date(),"\n*vertices",n,"\n",file=net)
  for(i in 1:n) cat(i,' "',IDs[i],'" ',xy[i,1],' ',xy[i,2],' 0.5\n',sep='',file=net)
  cat("*edgeslist\n",file=net)
  for(i in 1:n) if(L[i]>0) cat(i,nbs[[i]],"\n",file=net)
  close(net)
}
  
