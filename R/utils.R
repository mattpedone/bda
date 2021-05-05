gendata <- function(){
  n <- 1000
  pro=c(0.2,0.5,0.3)
  data <- vector(length=100)
  for(i in 1:n){
    u <- runif(1)
    if(u<pro[1]){
      #cat(i,"ciao1","\n")
      data[i] <- rnorm(1,mean=-2.1,sd=0.5)
    }
    else{
      if(u<(pro[1]+pro[2])){
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

rdirichlet <- function (n = 1, par = rep(1, 2)) 
{
  k = length(par)
  mat = matrix(0, n, k)
  for (i in 1:n) {
    sim = rgamma(k, shape = par, scale = 1)
    mat[i, ] = sim/sum(sim)
  }
  mat
}

my_gibbs_s <- function (niter, dat, mix) 
{
  n = length(dat)
  k = mix$k
  z = rep(0, n)
  ssiz = nxj = ssum = rep(0, k)
  mug = sigg = prog = matrix(0, nrow = niter, ncol = k)
  lopost = rep(0, niter)
  lik = matrix(0, n, k)
  prog[1, ] = rep(1, k)/k
  mug[1, ] = rep(mix$mu, k)
  sigg[1, ] = rep(mix$sig, k)
  for (j in 1:k) lik[, j] = prog[1, j] * dnorm(x = dat, mean = mug[1, 
                                                                   j], sd = sqrt(sigg[1, j]))
  lopost[1] = sum(log(apply(lik, 1, sum))) + sum(dnorm(mug[1, 
  ], mean(dat), sqrt(sigg[1, ]), log = TRUE)) - (10 + 1) * 
    sum(log(sigg[1, ])) - sum(var(dat)/sigg[1, ]) + 0.5 * 
    sum(log(prog[1, ]))
  for (i in 1:(niter - 1)) {
    for (t in 1:n) {
      prob = prog[i, ] * dnorm(dat[t], mean = mug[i, ], 
                               sd = sqrt(sigg[i, ]))
      #cat("iter: ", i, ", prob = ", prob, ", sum: ", sum(prob), "\n")
      if ((sum(prob) == 0))  
        #if ((sum(prob) == 0) | (is.nan(sum(prob))))  
        prob = rep(1, k)/k
      z[t] = sample(1:k, 1, prob = prob)
    }
    for (j in 1:k) {
      ssiz[j] = sum(z == j)
      nxj[j] = sum(as.numeric(z == j) * dat)
    }
    mug[i + 1, ] = rnorm(k, (mean(dat) + nxj)/(ssiz + 1), 
                         sqrt(sigg[i, ]/(ssiz + 1)))
    for (j in 1:k) ssum[j] = sum(as.numeric(z == j) * (dat - 
                                                         nxj[j]/ssiz[j])^2)
    sigg[i + 1, ] = 1/rgamma(k, shape = 0.5 * (20 + ssiz), 
                             rate = var(dat) + 0.5 * ssum + 0.5 * ssiz/(ssiz + 
                                                                          1) * (mean(dat) - nxj/ssiz)^2)
    prog[i + 1, ] = rdirichlet(1, par = ssiz + 0.5)
    for (j in 1:k) lik[, j] = prog[i + 1, j] * dnorm(x = dat, 
                                                     mean = mug[i + 1, j], sd = sqrt(sigg[i + 1, j]))
    lopost[i + 1] = sum(log(apply(lik, 1, sum))) + sum(dnorm(mug[i + 
                                                                   1, ], mean(dat), sqrt(sigg[i + 1, ]), log = TRUE)) - 
      (10 + 1) * sum(log(sigg[i + 1, ])) - sum(var(dat)/sigg[i + 
                                                               1, ]) + 0.5 * sum(log(prog[i + 1, ]))
  }
  list(k = k, mu = mug, sig = sigg, p = prog, lopost = lopost)
}
