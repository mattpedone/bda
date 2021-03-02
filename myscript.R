plotmix <- function(mu1 = 2.5, mu2 = 0, p = 0.7, n = 5000, plottin = TRUE, nl = 50){
  pbar = 1 - p
  u = runif(n)
  sampl = rnorm(n) + (u <= p) * mu1 + (u > p) * mu2
  mu1 = mu2 = seq(min(sampl), max(sampl), 0.1)
  mo1 = mu1 %*% t(rep(1, length(mu2)))
  mo2 = rep(1, length(mu2)) %*% t(mu2)
  ca1 = -0.5 * mo1 * mo1
  ca2 = -0.5 * mo2 * mo2
  like = 0 * mo1
  for(i in 1:n){
    like = like + log(p * exp(ca1 + sampl[i] * mo1) + pbar * exp(ca2 + sampl[i] * mo2))
  }
  like = like + 0.1 * (ca1 + ca2)
  if (plottin) {
    par(mar = c(4, 4, 1, 1))
    image(mu1, mu2, like, xlab = expression(mu[1]), ylab = expression(mu[2]), 
          col = heat.colors(250))
    contour(mu1, mu2, like, levels = seq(min(like), max(like), 
                                         length = nl), add = TRUE, drawlabels = FALSE)
  }
  list(sample = sampl, like = like)
}

out <- plotmix(mu1 = 2.5, mu2 = 0, p = 0.7, n = 500, plottin = TRUE, nl = 50)

hist(out$sample, breaks = 5000)

#costruisci progetto my_proj
#crea file utils.R e ci salvi plotmix
#crea script
#crea file mkd
#testo molto semplice 
#inserisci commenti nel codice
#formule di latex nell introduzione
#esempio link
#esempio R "inline"