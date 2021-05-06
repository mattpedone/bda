# samples from a simple mixture of 3 (specified) gaussians
gendata <- function(n = 1000, pro = c(0.2,0.5,0.3)){
  if(length(pro) != 3){
    stop("The length of probabilities must be equal to 3!")
  }
  data <- vector(length = n)
  for(i in 1:n){
    u <- runif(1)
    if(u < pro[1]){
      #cat(i,"ciao1","\n")
      data[i] <- rnorm(1,mean=-2.1,sd=0.5)
    }
    else{
      if(u < (pro[1] + pro[2])){
        #cat(i,"ciao2","\n")
        data[i] <- rnorm(1,mean=0,sd=0.5)
      }
      else{
        #cat(i,"ciao3","\n")
        data[i] <- rnorm(1,mean=2.3,sd=0.5) 
      }
    }
  }
  return (data)
}

#samples from a dirichlet rv using independent gamma random variables
rdirichlet <- function(n = 1, alpha = c(1,1,1)){
  K <- length(alpha)
  q <- matrix(0, n, K)
  for(i in 1:n){
    z <- rgamma(K, shape = alpha, scale = 1.0)
    q[i, ] <- z/sum(z)
  }
  return(q)
}

my_gibbs_s <- function (niter, y, mixpar){
  #quantities & hyperparameters
  n <- length(y)#number of observations
  G <- mixpar$G #number of components
  nu <- mixpar$nu#prior for shaper parameter IG
  alphag <- mixpar$alpha#prior for Dirichlet
  mg <- mean(y)#prior mean for m_g
  s2 <- var(y)#rate parameter for IG
  
  #objects to store stuff
  z <- rep(0, n)#latent variables
  ng <- ngyz <- ssum <- rep(0, G)#n_g, n_g\times\bar{y}_g(\bm z), n_g\times\hat{s}_{g}^{2}
  mug <- sigg <- etag <- matrix(0, nrow = niter, ncol = G)#\mu_g, \sigma_g, eta_g
  logpost <- rep(0, niter)#logposterior
  lik <- matrix(0, n, G)#likelihood
  
  #initialization (riga 1 algorithm 1)
  etag[1, ] <- rep(1, G)/G
  mug[1, ] <- rep(mixpar$mu, G)
  sigg[1, ] <- rep(mixpar$sig, G)
  for(g in 1:G){
    lik[, g] <- etag[1, g] * dnorm(x = y, mean = mug[1, g], sd = sqrt(sigg[1, g]))
  }
  logpost[1] <- sum(log(apply(lik, 1, sum))) + sum(dnorm(mug[1,], mg, sqrt(sigg[1, ]), log = TRUE)) - 
    (10 + 1) * sum(log(sigg[1, ])) - sum(c(s2)/sigg[1, ]) + 0.5 * sum(log(etag[1, ]))
  
  #begins the MCMC (riga 2 algorithm 1)
  for(t in 1:(niter - 1)){
    #loop over observation (riga 3 algorithm 1)
    for(i in 1:n){
      #compute p(z_i=g|\theta, \eta) eq. 2.1
      prob <- etag[t, ] * dnorm(y[i], mean = mug[t, ], sd = sqrt(sigg[t, ]))
      #for numerical stability
      prob[which(is.nan(prob))] <- 10.0^(-4)
      if((sum(prob) == 0)){
        prob <- rep(1, G)/G
      }
      z[i] <- sample(1:G, 1, prob = prob)
    }
    
    #compute useful quantities
    for(g in 1:G){
      ng[g] <- sum(z == g)#n_g
      ngyz[g] <- sum(as.numeric(z == g) * y)#n_g\times\bar{y}_g(\bm z)
    }
    
    #posterior sampling
    mug[t + 1, ] <- rnorm(G, (mg + ngyz)/(ng + 1), sqrt(sigg[t, ]/(ng + 1)))
    for(g in 1:G){
      ssum[g] = sum(as.numeric(z == g) * (y - ngyz[g]/ng[g])^2)#n_g\times\hat{s}_{g}^{2}
      }
    sigg[t + 1, ] = 1/rgamma(G, shape = 0.5 * (nu + ng), rate = c(s2) + 0.5 * ssum + 0.5 * ng/(ng + 1) * (mg - ngyz/ng)^2)
    etag[t + 1, ] = rdirichlet(1, alpha = ng + alphag)
    
    #update quantities (likelihood & loglikelihood)
    for(g in 1:G){
      lik[, g] = etag[t + 1, g] * dnorm(x = y, mean = mug[t + 1, g], sd = sqrt(sigg[t + 1, g]))
      }
    logpost[t + 1] = sum(log(apply(lik, 1, sum))) + 
      sum(dnorm(mug[t + 1, ], mg, sqrt(sigg[t + 1, ]), log = TRUE)) - 
      (10 + 1) * sum(log(sigg[t + 1, ])) - sum(c(s2)/sigg[t + 1, ]) + 
      0.5 * sum(log(etag[t + 1, ]))
  }
  #return
  res <- list(G = G, mu = mug, sig = sigg, p = etag, logpost = logpost)
  return(res)
}
