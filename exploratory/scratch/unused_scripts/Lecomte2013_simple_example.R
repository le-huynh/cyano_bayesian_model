################################################################################
### Zero-inflated data simulation
################################################################################

### Observations number
n_obs <- 50

### Parameters
mu <- 2
rho_a <- 1
rho_b <- 0.1
SV =  rgamma(n=n_obs, 1, 1)

### Data generation
lambda <-  exp(mu)*SV
ngis  <-  rpois(n=n_obs, lambda=lambda )
Y <- rgamma(n=n_obs, ngis*rho_a, rho_b)

data_CPG <- list(Y = Y, n_obs = length(Y), SV = SV)



################################################################################
### Stan inference
################################################################################
M1_CPG <-"
data {
int<lower=0> n_obs;
real<lower=0> SV[n_obs];
real<lower=0> Y[n_obs];
}

parameters {
real mu;
real<lower=0> rho_a;
real<lower=0> rho_b;
}

transformed parameters {
real <lower=0> lambda[n_obs];
real<lower=0, upper=1>  proba[n_obs];

  for (s in 1:n_obs){
    lambda[s] <-  exp(mu)*SV[s];
    proba[s] <- 1 - exp(-lambda[s]);
  }

}

model {

int ngis[n_obs];

// Priors
rho_a ~ gamma(0.01, 0.01);
rho_b ~ gamma(0.01, 0.01);
mu ~ normal(0, 10);

//Observation model
for (s in 1:n_obs){
  (Y[s] == 0) ~ bernoulli(proba[s]);
  
  if (Y[s] > 0)
    ngis[s] ~ poisson(lambda[s])T[1,];
    Y[s] ~ gamma(ngis[s]*rho_a, rho_b); 
  }
}
"

require(rstan)

## Numbers of chains
n_chains <- 3

## Numbers of interations
n_iter <- 10000

## Initial values
inits_fc <- function(chain_id = 1){
  mu <- rnorm(1,0,1)
  rho_a <- runif(1,0,10)
  rho_b <- runif(1,0,10)
  ngis <- round(runif(n_obs,2,10), digits=0)
  list(mu=mu, rho_a=rho_a, rho_b=rho_b, ngis=ngis)
}
init_ll <- lapply(1:n_chains, function(id) inits_fc(chain_id = id))


fit_M1_CPG <- stan(model_code = M1_CPG,
                            data = data_CPG,
                            iter = n_iter,
                            chains = n_chains,
                            init=init_ll,
                            verbose=TRUE)
print(fit_M1_CPG)
summary(fit_M1_CPG)


################################################################################
### JAGS inference
################################################################################

M1_CPG_JAGS <-"model{
  
  ### Covariates
  for (s in 1:n_obs){
    lambda[s] <- exp(mu)*SV[s]
  }
  
  ### Observation model
  # Strictly positive Observation
  for ( s in 1:n_pres){
    ngis[s] ~ dpois(lambda[pres[s]])T(1,)
    Y_a[s] <- rho_a * ngis[s]
    Y[pres[s]] ~ dgamma(Y_a[s], rho_b)
  }
  
  # Zero Observation
  for ( s in 1:n_abs){
    proba[s] <- 1 - exp(-lambda[abs[s]])
    Y[abs[s]] ~ dbern(proba[s])
  }
  
  ### Prior
  rho_a ~ dgamma(0.01, 0.01)
  rho_b ~ dgamma(0.01, 0.01)
  mu ~ dnorm(0, 0.01)
}"
writeLines(M1_CPG_JAGS,con="M1_CPG_JAGS.txt")
require(rjags)


## Numbers of chains
n_chains <- 3

## Numbers of interations
n_iter <- 10000

## Prepare data for JAGS, identify absence and presence
abs <- which(Y==0)
n_abs <- length(abs)
pres <- which(Y>0)
n_pres <- length(pres)
data_CPG_JAGS <- list(Y = Y, n_obs = length(Y), SV=SV,
                      abs=abs, n_abs=n_abs,
                      pres=pres, n_pres=n_pres)
## Jags inference
fit_M1_CPG_JAGS <- jags.model(file="M1_CPG_JAGS.txt",
                   data = data_CPG_JAGS,
                   n.chains = n_chains)
update(fit_M1_CPG_JAGS, n.iter = 10000)
codaSamples_M1_CPG_JAGS <- coda.samples( fit_M1_CPG_JAGS ,
                            variable.names=c('mu', 'rho_a', 'rho_b') ,
                            n.iter=n_iter , thin=10)
summary(codaSamples_M1_CPG_JAGS)
#plot(codaSamples_M1_CPG_JAGS)

#-------------------------------------------------------------------------------
### LY - test
library(R2jags)

paraList = c("rho_a", "rho_b", "mu")

omg_jags <- jags(data = data_CPG_JAGS,
                  model.file = "M1_CPG_JAGS.txt",
                  parameters.to.save = paraList,
                  n.iter = n_iter,
                  n.burnin = n.burnin,
                  n.chains = n_chains,
                  n.thin = n.thin
                  # inits = inits
)

## Posterior predictive check
post_omg = CalvinBayes::posterior(omg_jags)

library(tidyverse)
paramsDF = post_omg %>%
          slice_sample(n=200)

paramsDF %>% head()

paramsDF1 = select(paramsDF, mu, rho_a, rho_b)

SVok = SV

# n = 50 because n_obs = 50
simObs = function(mu, rho_a, rho_b) {
          lambda = exp(mu) * SVok
          ngis = rpois(n = 50, lambda = lambda)
          Y = rgamma(n = 50, ngis * rho_a, rho_b)
          return(Y)
          
}

simsList = pmap(paramsDF1,simObs)

names(simsList) = paste0("sim",1:length(simsList))

simsDF = as_tibble(simsList)

simsDF

## create tidy version for plotting
plotDF = simsDF %>%
          pivot_longer(cols = everything()) 

## see random sample of plotDF rows
plotDF %>% slice_sample(n=10)  

obsDF = tibble(obs = data_CPG$Y)

colors = c("simulated" = "cadetblue", 
           "observed" = "navyblue")

ggplot(plotDF) +
          stat_density(aes(x=value, 
                           group = name,
                           color = "simulated"),
                       geom = "line",  # for legend
                       position = "identity") + #1 sim = 1 line
          stat_density(data = obsDF, aes(x=obs, 
                                         color = "observed"),
                       geom = "line",  
                       position = "identity",
                       lwd = 2) +
          scale_color_manual(values = colors) +
          labs(x = "Cyanocell",
               y = "Density Estimated from Data",
               color = "Data Type")

# https://www.causact.com/posterior-predictive-checks.html#posterior-predictive-checks