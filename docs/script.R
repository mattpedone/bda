rm(list=ls())

load("data/reading.RData")
source("R/fnchoff.R")
Y <- reading
n <- dim(Y)[1]
p <- dim(Y)[2]
n
p
summy <- summary(Y)
summy
ybar <- as.numeric(apply(Y, 2 , mean))
Sigma <- cov(Y)
corry <- cor(Y)
mu0 <- c(50, 50)
L0 <- matrix(c(625, 312.5, 312.5, 625), nrow = 2, ncol = 2)

nu0 <- p+2
S0 <- matrix(c(625, 312.5, 312.5, 625), nrow = 2, ncol = 2)

THETA <- SIGMA <- NULL
YS <- NULL
S <- 5000
cat("here starts the mcmc!", "\n")
for (s in 1:S) {
  ### update theta
  Ln <- solve(solve(L0) + n * solve(Sigma))
  mun <- Ln %*% (solve(L0) %*% mu0 + n * solve(Sigma) %*% ybar)
  theta <- rmvnorm(1, mun, Ln)
  ### update Sigma
  Sn <- solve(S0 + (t(Y) - c(theta)) %*% t(t(Y) - c(theta)))
  Sigma <- solve(rwish(1, nu0 + n, Sn))
  ###
  YS <- rbind(YS, rmvnorm(1, theta, Sigma))
  ### save results
  THETA <- rbind(THETA, theta)
  SIGMA <- rbind(SIGMA, c(Sigma))
}
cat("sampling is done", "\n")

output <- list()
output$Ypost <- YS
output$Sigmapost <- SIGMA
output$Thetapost <- THETA

save(output, file = "data/res.RData")
