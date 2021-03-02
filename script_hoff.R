rm(list=ls())
library(MASS)
library(ash)
source("fnchoff.R")

load("reading.RData")
#reading <- mvtnorm::rmvnorm(25, c(55, 50), diag(100, 2))
Y<-reading

mu0<-c(50,50)
L0<-matrix( c(625,312.5,312.5,625),nrow=2,ncol=2)

nu0<-4
S0<-matrix( c(625,312.5,312.5,625),nrow=2,ncol=2)

n<-dim(Y)[1] ; ybar<-apply(Y,2,mean)
Sigma<-cov(Y) ; THETA<-SIGMA<-NULL
YS<-NULL
##HOFF CODE
for(s in 1:5000){
  ###update theta
  Ln<-solve( solve(L0) + n*solve(Sigma) )
  mun<-Ln%*%( solve(L0)%*%mu0 + n*solve(Sigma)%*%ybar )
  theta<-rmvnorm(1,mun,Ln)  
  ###update Sigma
  Sn<- solve(S0 + ( t(Y)-c(theta) )%*%t( t(Y)-c(theta) ) )
  Sn
  Sigma<-solve( rwish(1, nu0+n, Sn) )
  ###
  YS<-rbind(YS,rmvnorm(1,theta,Sigma)) 
  ### save results 
  THETA<-rbind(THETA,theta) ; SIGMA<-rbind(SIGMA,c(Sigma))
}

quantile(  SIGMA[,2]/sqrt(SIGMA[,1]*SIGMA[,4]), prob=c(.025,.5,.975) )
quantile(   THETA[,2]-THETA[,1], prob=c(.025,.5,.975) )
mean( THETA[,2]-THETA[,1]); mean( THETA[,2]>THETA[,1]); mean(YS[,2]>YS[,1])

#### Figure 7.2 
par(mfrow=c(1,2),mgp=c(1.75,.75,0),mar=c(3,3,1,1))

plot.hdr2d(THETA,xlab=expression(theta[1]),ylab=expression(theta[2]) )
abline(0,1)

plot.hdr2d(YS,xlab=expression(italic(y[1])),ylab=expression(italic(y[2])), 
           xlim=c(0,100),ylim=c(0,100) )
points(Y[,1],Y[,2],pch=16,cex=.7)
abline(0,1)
