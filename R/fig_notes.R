# Figure 1
library(MASS)
gal <- galaxies/1000
c(width.SJ(gal, method = "dpi"), width.SJ(gal))
plot(x = c(5, 35), y = c(0, 0.25), type = "n", bty = "l",
     xlab = "velocity of galaxy (1000km/s)", ylab = "density")
rug(gal, col = "blue")
hist(gal, breaks = 25, freq = FALSE, add = TRUE)
lines(density(gal, width = 1.75, n = 200), lwd = 1.5, lty = 4, col = "red")

#Figure 2
library(sm)
n <- 100000
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
lines(yden, lwd = 3.0, xlim = c(0, 6))

#Figure 3
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

#Figure 4
library(bayess)
plotmix(mu1 = 2.5, mu2 = 0, p = 0.7, n = 500, plottin = TRUE, nl = 50)

#Figure 5
library(bayess)
plotmix(mu1 = 2.5, mu2 = 0, p = 0.5, n = 500, plottin = TRUE, nl = 50)

#Figure App Dir
library(DirichletReg)
source(file = "R/utils.R")

plot.DirichletRegData(DR_data(rdirichlet(1000, c(1, 1, 1))), cex = 0.5, 
                      a2d = list(colored = TRUE, c.grid = FALSE), 
                      dim.labels = c(expression(alpha[1]), expression(alpha[2]), 
                                     expression(alpha[3])))

plot.DirichletRegData(DR_data(rdirichlet(1000, c(.1, .1, .1))), cex = 0.5, 
                      a2d = list(colored = TRUE, c.grid = FALSE), 
                      dim.labels = c(expression(alpha[1]), expression(alpha[2]), 
                                     expression(alpha[3])))

plot.DirichletRegData(DR_data(rdirichlet(1000, c(10, 10, 10))), 
                      cex = 0.5, a2d = list(colored = TRUE, c.grid = FALSE), 
                      dim.labels = c(expression(alpha[1]), expression(alpha[2]), 
                                     expression(alpha[3])))

plot.DirichletRegData(DR_data(rdirichlet(1000, c(.6, .3, .1))), 
                      cex = 0.5, a2d = list(colored = TRUE, c.grid = FALSE), 
                      dim.labels = c(expression(alpha[1]), expression(alpha[2]), 
                                     expression(alpha[3])))

plot.DirichletRegData(DR_data(rdirichlet(1000, c(6, 3, 1))), 
                      cex = 0.5, a2d = list(colored = TRUE, c.grid = FALSE), 
                      dim.labels = c(expression(alpha[1]), expression(alpha[2]), 
                                     expression(alpha[3])))

plot.DirichletRegData(DR_data(rdirichlet(1000, c(12, 6, 2))), 
                      cex = 0.5, a2d = list(colored = TRUE, c.grid = FALSE), 
                      dim.labels = c(expression(alpha[1]), expression(alpha[2]), 
                                     expression(alpha[3])))

