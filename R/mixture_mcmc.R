rm(list=ls())
source(file = "R/utils.R")
set.seed(121)
y <- gendata()
##uncommenting the following line and setting G = 5, nu = 150, alphag = 1.5 we can observe label switching
#y <- scale(MASS::galaxies/1000)

#quantities for MCMC & hyperparameter specification
ndraw <- 10000
G <- 3
mixpar <- list(G = G, mu = mean(y), sig = var(y), nu = 20, alphag = .5)#nu = 150, alphag = 1.5#

#run Gibbs sampler
out <- my_gibbs_s(ndraw, y = y, mixpar = mixpar)

#mixture density plot
hist(y, prob=TRUE, main="", xlab="", ylab="", nclass=100, ylim = c(0, .5))#1.5
hist(y, prob=TRUE, main="", xlab="", ylab="", nclass=100, ylim = c(0, 0.5))#2.0
x <- yl <- seq(min(y), max(y), length=150)
yy <- matrix(0, ncol=150, nrow=ndraw)

for(i in 1:150){
  yy[,i]=apply(out$p*dnorm(x[i],mean=out$mu, sd=sqrt(out$sig)),1,sum)
  yl[i]=mean(yy[,i], na.rm = T)
}

for(t in (ndraw/2):ndraw){
  lines(x, yy[t,], col="gold")
}

lines(x, yl, lwd=2.3,col="red")

#Convergence of the three types of parameters of the normal mixture
colors <- c("steelblue3", "sienna3", "gold4", "azure3", "aquamarine2")
plot(out$p[,1],type="l", col="steelblue3", xlab="iterations",ylab="p", ylim = c(0, 0.6))
for(g in 2:G){
  lines(out$p[,g],type="l",col=colors[g],xlab="iterations",ylab="p")
}

plot(out$mu[,1],type="l", col="steelblue3", xlab="iterations",ylab=expression(mu), 
     ylim = c(-2.5, 2.5))
for(g in 2:G){
  lines(out$mu[,g],type="l",col=colors[g],xlab="iterations",ylab=expression(mu))
}

plot(out$sig[,1],type="l", col="steelblue3", xlab="iterations",ylab=expression(sigma), 
     ylim = c(0.0, 0.5))
for(g in 2:G){
  lines(out$sig[,g],type="l",col=colors[g],xlab="iterations",ylab=expression(sigma))
}

#2 x 2 plot of the Gibbs sample for the three types of parameters of a normal mixture
plot(out$mu[,1], out$p[,1], col="steelblue3", xlim = c(-2.5, 2.5), ylim = c(0, 0.6), 
     xlab=expression(mu), ylab="p")
for(g in 2:G){
  points(out$mu[,g], out$p[,g], col=colors[g])
}

plot(out$sig[,1], out$p[,1], col="steelblue3", xlim = c(0.0, 0.8), ylim = c(0.0, 0.6), 
     xlab=expression(sigma), ylab="p")
for(g in 2:G){
  points(out$sig[,g], out$p[,g], col=colors[g])
}

plot(out$mu[,1], out$sig[,1], col="steelblue3", xlim = c(-2.5, 2.5), ylim = c(0, .75), 
     xlab=expression(mu), ylab=expression(sigma))
for(g in 2:G){
  points(out$mu[,g], out$sig[,g], col=colors[g])
}

