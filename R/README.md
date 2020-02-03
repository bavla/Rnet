# R functions

## Pajek R

 by Vladimir Batagelj, November 2019

reading and saving of Pajek data in R (matrices and vectors)

 https://github.com/bavla/cluRC/blob/master/readPajekNet.R


### clu2vector(f,skip=1)

reads a Pajek's clustering file f into vector


### vec2vector(f,skip=1)

reads a Pajek's vector file f into vector

### net2matrix(f)

reads a network from Pajek's net file; skips initial comments lines


### matrix2net(M,Net="Pajek.net")

saves a square matrix M to Pajek's net file Net

### bimatrix2net(M,Net="Pajek.net")

saves a two-mode matrix M to Pajek's net file Net


### uv2net(u,v,w=NULL,Net="Pajek.net",twomode=FALSE)

saves a links list [(u,v)] or [(u,v,w)]  to Pajek's net file Net
}

### vector2clu <- function(C,Clu="Pajek.clu"){
  n <- length(C); clu <- file(Clu,"w")
  cat("% clu2Pajek",date(),"\n*vertices",n,"\n",file=clu)
  cat(C,sep="\n",file=clu)
  close(clu)
}

### vector2vec <- function(X,Vec="Pajek.vec"){
  n <- length(X); vec <- file(Vec,"w")
  cat("% vec2Pajek",date(),"\n*vertices",n,"\n",file=vec)
  cat(X,sep="\n",file=vec)
  close(vec)
}
