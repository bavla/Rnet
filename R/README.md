# R functions

## Pajek R

 by Vladimir Batagelj, November 2019

reading and saving of Pajek data in R (matrices and vectors)

 source("https://raw.githubusercontent.com/bavla/Rnet/master/R/Pajek.R")


### clu2vector(f,skip=1)

reads a Pajek's clustering file f into a vector.


### vec2vector(f,skip=1)

reads a Pajek's vector file f into a vector.

### net2matrix(f)

reads a network from Pajek's net file; skips initial comments lines.


### matrix2net(M,Net="Pajek.net",encoding="UTF-8")

saves a square matrix M to a Pajek's net file Net.

### bimatrix2net(M,Net="Pajek.net",encoding="UTF-8")

saves a two-mode matrix M to a Pajek's net file Net.


### uv2net(u,v,w=NULL,Net="Pajek.net",twomode=FALSE,encoding="UTF-8")

saves a links list [(u,v)] or [(u,v,w)]  to Pajek's net file Net.


### uvFac2net(u,v,w=NULL,r=NULL,t=NULL,Net="Pajek.net",twomode=FALSE,encoding="UTF-8")

factorized link start and end vectors u and v  saves to Pajek's net file Net. If provided, it includes also weights w, relation numbers r, and time points t.

### vector2clu(C,Clu="Pajek.clu")

saves the integer vector C as a Pajek's partition (clustering).


### vector2vec(X,Vec="Pajek.vec")

saves the numerical vector X as a Pajek's vector.



### CorEu(W,p=1)

Corrected Euclidean distance

http://vladowiki.fmf.uni-lj.si/doku.php?id=notes:clu:cluster
