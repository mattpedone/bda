#Figure 1
n <- 10000
pro <- c(0.3,0.5,0.2)
y <- vector(length=n)
label <- vector(length=n)
for(i in 1:n){
  u <- runif(1)
  if(u<pro[1]){
    #cat(i,"ciao1","\n")
    y[i] <- rnorm(1, mean = 2.0, sd = 1.0)
    label[i] <- 1
  } else{
    if(u<(pro[1]+pro[2])){
      #cat(i,"ciao2","\n")
      y[i] <- rnorm(1, mean = 3.0, sd = 0.5)
      label[i] <- 2
    } else{
      #cat(i,"ciao3","\n")
      y[i] <- rnorm(1, mean = 3.4, sd = 1.3) 
      label[i] <- 3
    }
  }
}
yden <- density(y)
mymixture <- list(y = y, label = label)
labf <- factor(mymixture$label, levels = c(1, 2, 3))
sm.density.compare(mymixture$y, mymixture$label, xlab="y", ylab="density",
                   xlim = c(0, 6))

#Figure 2
library(plotly)
library(mvtnorm)
n <- 1000
pro <- c(0.7, 0.3)
y <- matrix(0, nrow = n, ncol = 2)
label <- vector(length = n)

for(i in 1:n){
  u <- runif(1)
  if(u<pro[1]){
    y[i,] <- rmvnorm(n = 1, mean = c(-1, 1), 
                     sigma = matrix(c(1, .7, .7, 1), nrow=2))
  } else{
      y[i,] <- rmvnorm(n = 1, mean = c(2.5, .5), 
                       sigma = matrix(c(1, -.7, -.7, 1), nrow=2))
    }
}
mydf <- data.frame(y)
kd <- with(mydf, MASS::kde2d(X1, X2, n = n))
fig <- plot_ly(x = kd$x, y = kd$y, z = kd$z) %>% add_surface()
fig

#Figure 3
library(bayess)
plotmix(mu1 = 2.5, mu2 = 0, p = 0.7, n = 500, plottin = TRUE, nl = 50)
