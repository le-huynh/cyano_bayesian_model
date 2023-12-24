# Haakonsson2020

#-------------------------------------------------------------------------------
# THE MODEL
#-------------------------------------------------------------------------------
Haakonsson <- "model{
          ### Covariates
          for (s in 1:n_obs){
                    log(lambda[s]) <- theta0 +
                                        theta1 * WT[s] +
                                        theta2 * (WT[s] ^ 2) +
                                        theta3 * cond[s] +
                                        theta4 * WT[s] * cond[s] +
                                        eta_ij +
                                        nu_ik +
                                        epsilon_ijk

          }
          
          ### Observation model
          # Strictly positive Observation
          for ( s in 1:n_pres){
                    M[s] ~ dpois(lambda[pres[s]])T(1,)
                    Y_a[s] <- a * M[s]
                    Y[pres[s]] ~ dgamma(Y_a[s], b)
          }
          # Zero Observation
          for ( s in 1:n_abs){
                    proba[s] <- 1 - exp(-lambda[abs[s]])
                    Y[abs[s]] ~ dbern(proba[s])
          }

          ### Prior
          # Regression coefficients
          theta[i] ~ dnorm(0,100)
          # Gamma shape and rate parameters
          a ~ dgamma(0.01, 0.01)
          b ~ dgamma(0.01, 0.01)
          # Random effects
          eta_ij ~ dnorm(0, var_eta)
          nu_ik ~ dnorm(0,var_nu)
          var_eta ~ dnorm(0,10)
          var_nu ~ dnorm(0,10)
          # Observation error
          epsilon_ijk ~ dnorm(0,var_eps)
          var_eps ~ dnorm(0,10)
          var_eta ~
          var_nu ~
          # Observation error
          epsilon_ijk ~ dnorm(0, var_epsilon)
          var_epsilon ~ dnorm(0,10)

}
"
writeLines(Haakonsson,con="Haakonsson.txt")

#-------------------------------------------------------------------------------
# THE DATA
#-------------------------------------------------------------------------------
# identify absence and presence
abs <- which(Y==0)
n_abs <- length(abs)
pres <- which(Y>0)
n_pres <- length(pres)
dataList <- list(Y = biovolume,
                      n_obs = length(Y), 
                      WT = WaterTemp,
                      cond = conductivity, 
                      abs = abs, 
                      n_abs = n_abs,
                      pres = pres, 
                      n_pres = n_pres)

#-------------------------------------------------------------------------------
# INTIALIZE THE CHAINS.
# Let JAGS do it automatically...
#-------------------------------------------------------------------------------
# RUN JAGS
require(rjags)
fit_M1_CPG_JAGS <- jags.model(file="Haakonsson.txt",
                              data = dataList,
                              n.chains = 5)
update(fit_M1_CPG_JAGS, n.iter = 2000000)
codaSamples_M1_CPG_JAGS <- coda.samples( fit_M1_CPG_JAGS ,
                                         variable.names=c('mu', 
                                                          'rho_a', 
                                                          'rho_b') ,
                                         n.iter = 2000000 , 
                                         thin = 10)
summary(codaSamples_M1_CPG_JAGS)
#plot(codaSamples_M1_CPG_JAGS)

