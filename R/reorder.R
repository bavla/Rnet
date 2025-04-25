# ClusNet - clustering in networks
# Reorder units in clustering hierarchy
#  https://github.com/bavla/NormNet/blob/main/data/natalija/reorder.md
# by Vladimir Batagelj, April 17, 2022
# February 13, 2025  add CorSalton, Balassa
# Februray 17, 2025  add coreDendro

Balassa <- function(P){
   R <- rowSums(P); C <- rowSums(t(P)); T <- sum(R); Z <- P
   for(u in 1:nrow(P)) for(v in 1:ncol(P)) Z[u,v] <- P[u,v]*T/R[u]/C[v]
   Z <- log2(Z); Z[Z == -Inf] <- 0; return(Z)
}

CorSalton <- function(W){
   S <- W; diag(S) <- 1; n = nrow(S)
   for(u in 1:(n-1)) for(v in (u+1):n) S[v,u] <- S[u,v] <- 
      (as.vector(W[u,]%*%W[v,])+(W[u,u]-W[v,u])*(W[v,v]-W[u,v]))/
      sqrt(as.vector(W[u,]%*%W[u,])*as.vector(W[v,]%*%W[v,])) 
   return(S)
}

CorEuclid <- function(W){
   D <- W; diag(D) <- 0; n = nrow(D)
   for(u in 1:(n-1)) for(v in (u+1):n) D[v,u] <- D[u,v] <- 
      sqrt(sum((W[u,]-W[v,])**2) + 2*(W[u,u]-W[u,v])*(W[v,u]-W[v,v])) 
   return(D)
}

Salton <- function(W){
   S <- W; diag(S) <- 1; n = nrow(S)
   for(u in 1:(n-1)) for(v in (u+1):n) S[v,u] <- S[u,v] <- 
      (as.vector(W[u,]%*%W[v,]))/
      sqrt(as.vector(W[u,]%*%W[u,])*as.vector(W[v,]%*%W[v,])) 
   return(S)
}

Euclid <- function(W){
   D <- W; diag(D) <- 0; n = nrow(D)
   for(u in 1:(n-1)) for(v in (u+1):n) D[v,u] <- D[u,v] <- 
      sqrt(sum((W[u,]-W[v,])**2)) 
   return(D)
}

minCl <- function(u,v,T){
  if(min(u,v)==0) return(T[max(u,v)])
  # cat(u," ",v,":",T[u]," ",T[v],"\n")
  if(u==v) return(u)
  return( if(T[u]<T[v]) minCl(T[u],v,T) else minCl(u,T[v],T) ) 
}

toFather <- function(tm){
  n <- nrow(tm); T <- rep(0,2*n+1)
  for(i in 1:n){
    for(j in 1:2){
      p <- tm[i,j]
      if(p<0) T[-p] <- i+n+1 else T[n+1+p] <- i+n+1
    }
  }
  return(T)
}

flip <- function(k,T) {t <- T[k,1]; T[k,1] <- T[k,2]; T[k,2] <- t; return(T)}

# T <- toFather(t$merge)
# n <- nrow(t$merge)+1
# s <- t; t$merge <- flip(minCl(8,2,T)-n,t$merge); hm()

coreDendro <- function(lab,core){
  n <- length(lab);
  clu <- list(merge=matrix(0,nrow=n-1,ncol=2),height=rep(0,n-1),
    order=1:n,labels=lab,method="coreDendro",call=NULL,
    dist.method="core level")
  attr(clu,"class") <- "hclust"
  h <- core[1]; d <- 1; v <- -1 
  for(u in 1:(n-1)){
    clu$merge[u,1] <- v; clu$merge[u,2] <- -u-1
    clu$value[u]<- core[u+1]; v <- u
    if(core[u+1]<h) {h <- core[u+1]; d <- d+1}
    clu$height[u] <- d
  }
  return(clu)
}


