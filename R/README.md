# R functions

## Pajek R

 by Vladimir Batagelj, November 2019

reading and saving of Pajek data in R (matrices and vectors)

 source("https://raw.githubusercontent.com/bavla/Rnet/master/R/Pajek.R")


### clu2vector(f,skip=1)

reads a Pajek's clustering file f into a vector.


### vec2vector(f,skip=1)

reads a Pajek's vector file f into a vector.

### net2matrix(f,nolink=0)

reads a network from Pajek's net file; skips initial comments lines.


### matrix2net(M,Net="Pajek.net",encoding="UTF-8",nolink=0)

saves a square matrix M to a Pajek's net file Net.

### bimatrix2net(M,Net="Pajek.net",encoding="UTF-8")

saves a two-mode matrix M to a Pajek's net file Net.

!!! ???? preveri
### uv2net(u,v,w=NULL,Net="Pajek.net",twomode=FALSE,encoding="UTF-8")

saves a links list [(u,v)] or [(u,v,w)]  to Pajek's net file Net.


### uvFac2net(u,v,w=NULL,r=NULL,t=NULL,Net="Pajek.net",twomode=FALSE,encoding="UTF-8")

factorized link start and end vectors u and v  saves to Pajek's net file Net. If provided, it includes also weights w, relation numbers r, and time points t.

### uvrwt2net(u,v,w=NULL,r=NULL,t=NULL,Net="Pajek.net",twomode=FALSE,encoding="UTF-8")

### uvLab2net(Lab,U,V,W,Net="Pajek.net",dir=FALSE,encoding="UTF-8")

### vector2clu(C,Clu="Pajek.clu")

saves the integer vector C as a Pajek's partition (clustering).

### vecnom2clu(N,Clu="Pajek.clu",na=0,encoding="UTF-8")

saves the nominal vector N as a Pajek's partition (clustering) with the legend.

### vector2vec(X,Vec="Pajek.vec")

saves the numerical vector X as a Pajek's vector.



### CorEu(W,p=1)

Corrected Euclidean distance

http://vladowiki.fmf.uni-lj.si/doku.php?id=notes:clu:cluster

### RC2dendro(C)

Transforming Pajek's hierarchical clusterings into R's.

### orDendro(m,i)

### orSize(m,i) 

### derivedTree(R,type='rank')

Transforms an R clustering into the corresponding "balanced" version -
type in { 'rank', 'total', 'count' }.

### varCutree(R,var,vmin,vmax)

Alternative cutting of clusters.


## iGraph+

source("https://raw.githubusercontent.com/bavla/Rnet/master/R/igraph+.R")

write.graph.paj <- function(N,file="test.paj",vname="name",coor=NULL,va=NULL,ea=NULL,weight="weight",ecolor="color")

write.graph.netsJSON <- function(N,file="test.json",vname="name" ){

graph.reverse <- function (graph) {

top <- function(v,k){

read_Pajek_clu <- function(f,skip=1){

read_Pajek_vec <- function(f,skip=1){

extract_clusters <- function(N,atn,clus){

node_cut <- function(N,atn,t){

link_cut <- function(N,atn,t){

fname <- function(x) x[1]   # first name

canam <- function(x) paste0("#",x[1])  # canonical name

namec <- function(x) paste0(x,collapse=",")  # name list
