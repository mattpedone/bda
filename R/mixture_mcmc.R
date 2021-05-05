rm(list=ls())
source(file = "R/utils.R")

data <- gendata()
Ndraw <- 1000
mix=list(k=3,mu=mean(data),sig=var(data))
simu=my_gibbs_s(Ndraw, dat = data, mix = mix)
hist(data,prob=TRUE,main="",xlab="",ylab="",nclass=100)
x=y=seq(min(data),max(data),length=150)
yy=matrix(0,ncol=150,nrow=Ndraw)
for (i in 1:150){
  yy[,i]=apply(simu$p*dnorm(x[i],mean=simu$mu,
                            sd=sqrt(simu$sig)),1,sum)
  y[i]=mean(yy[,i])
}
for (t in (Ndraw/2):Ndraw)
  lines(x,yy[t,],col="gold")
lines(x,y,lwd=2.3,col="red")

simu$k
apply(simu$mu, 2, summary)
