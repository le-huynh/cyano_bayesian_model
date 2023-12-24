#---------------
#' title: "NagaData_ CPG_ DATA ANALYSIS"
#' author: "Ly"

#' output: doc_document
#-------------------------------------------------------------------------------
library(rethinking)
library(bayesplot)
library(CalvinBayes)
#-------------------------------------------------------------------------------
# Naga DATA
#-------------------------------------------------------------------------------

library(here)
Naga_data <- read.csv(here("Data","Naga_data.csv"))
View(Naga_data)
attach(Naga_data)

library(dplyr)
# Compute TSI value from Chl-a
Naga <- Naga_data %>%
          mutate(TSI_chla = 10* (6 - ((2.04 - 0.68 * log(Chla)) / log(2))))
          

library(tidyr)
# PC - mcyB data: round () --> replace_na(0)
PC_r0 = ifelse (Naga$PC < 1, 0, round(Naga_data$PC)) %>%
          replace_na(0)
mcyB_r0 = ifelse (Naga$mcyB < 1, 0, round(Naga_data$mcyB)) %>%
          replace_na(0)

str(Naga)

#' ### __Question__: Predict `cyanobacteria cell ~ Air_Temp + TSI`
#' 1. `cyano_cell`: outcome: 
#' * WHO guideline -> recreational water: low - medium - high risk:
#' 0 - 20000 - 100000 - more than 100000 cells/mL
#' * scale: 
#' ** raw data [YES -used]
#' ** `/max(PC)`-> range [0,1]-> observed data = 0-> meaningful data [NO-unused]
#' ** `sqrt()` --> square-root-transformation -> right-skewed data
#' 2. `Air_Temp`
#' * data_range: 10 - 30 oC --> temp in spring - late autumn
#' * natural_range: 0 - 50 
#' * scale_range: mean 0, sd = 1
#' 3. `TSI`:
#' * Why TSI? 
#' ** trophic state of lake/ reservoir
#' ** can be computed through many parameters: Chl-a , Secchi Depth, TN, TP
#' EPA guideline --> TSI comptuted from above parameter --> can use surrogate
#' * data_range: 36 - 89
#' * Range: 0 - 100
#' * Scale: standardize: mean = 0, sd = 1

srPC = sqrt(PC_r0)
srmcyB = sqrt(mcyB_r0)

ztemp = (Naga$Air_Temp - mean(Naga$Air_Temp)) / sd(Naga$Air_Temp)
zTSI = (Naga$TSI_chla - mean(Naga$TSI_chla)) / sd(Naga$TSI_chla)

Y = PC_r0
Y = mcyB_r0
Y = srPC
Y = srmcyB

# identify absence and presence
abs <- which(Y == 0)
n_abs <- length(abs)
pres <- which(Y > 0)
n_pres <- length(pres)

dataList <- list(Y = Y,
                 Temp = ztemp,
                 TSI = zTSI,
                 n_obs = length(Y),
                 abs = abs, 
                 n_abs = n_abs,
                 pres = pres, 
                 n_pres = n_pres)


#-------------------------------------------------------------------------------
# THE MODEL
#-------------------------------------------------------------------------------

Naga_CPG <- "model {
          
          ### Covariates
          for (s in 1:n_obs){
                    log(lambda[s]) <- theta0 +
                                        theta1 * Temp[s] +
                                        theta2 * TSI[s] +
                                        theta3 * Temp[s] * TSI[s] # +
                    # eta_ij +
                    # nu_ik +
                    # epsilon_ijk
          }
          
          ### Observation model
          # Strictly positive Observation
          for ( s in 1:n_pres){
                    N[s] ~ dpois(lambda[pres[s]])T(1,)
                    Y_a[s] <- a * N[s]
                    Y[pres[s]] ~ dgamma(Y_a[s], b)
          }
          # Zero Observation
          for ( s in 1:n_abs){
                    proba[s] <- 1 - exp(-lambda[abs[s]])
                    Y[abs[s]] ~ dbern(proba[s])
          }
          
          ### Prior
          # Regression coefficients
          theta0 ~ dnorm(0,5) 
          theta1 ~ dnorm(0,1) 
          theta2 ~ dnorm(0,1)
          theta3 ~ dnorm(0,1)

          # Gamma shape and rate parameters
          a ~ dgamma(0.01, 0.01)
          b ~ dgamma(0.01, 0.01)

          # Random effects
          # eta_ij ~ dnorm(0, var_eta)
          # nu_ik ~ dnorm(0,var_nu)
          # var_eta ~ dnorm(0,10)
          # var_nu ~ dnorm(0,10)
          # Observation error
          # epsilon_ijk ~ dnorm(0,var_eps)
          # var_eps ~ dnorm(0,10)
}
"
writeLines(Naga_CPG, con="Naga_model.txt" )

#-------------------------------------------------------------------------------                    
## Specify PRIOR
#-------------------------------------------------------------------------------
#' `theta0 ~ dnorm(0,5)` WHY?
#' `theta0` has normal distribution --> `lambda` has log-normal distribution
#' plot a log-normal with values for the (normal) mean and standard deviation 
#' 
#' Example: Flat prior `theta0 ~ dnorm(0,10)`
#' range: [0, 20000] --> range of cyano_cell data
curve( dlnorm( x , 0 , 10 ) , from=0 , to=20000 , n=200 )
#' plot shows huge spike right around 0 - that means 0 cells on average -
#' and a very long tail. 
#' How long is the tail?
#' Mean of log-normal distribution:
a <- rnorm(1e4,0,10) 
lambda <- exp(a) 
mean( lambda )
#' result = 9.622994e+12 => impossibly large --> too many cells
#' 
#' Choose: `theta0 ~ dnorm(0,5)`
curve( dlnorm( x , 0 , 5 ) , from=0 , to=20000 , n=200 )
a <- rnorm(1e4,0,5) 
lambda <- exp(a) 
mean( lambda )
#' mean of log-normal `lambda`: from 2e4 to 1e5
#' 
#' 

#-------------------------------------------------------------------------------
## Re-allocate credibility

#-------------------------------------------------------------------------------
# INITIALIZE CHAIN
# Let JAGS do it automatically...

#-------------------------------------------------------------------------------
# GENERATE CHAIN
#-------------------------------------------------------------------------------
library(R2jags)

# Make the same "random" choices each time this is run.
# This makes the Rmd file stable --> can comment on specific results.
set.seed(12345)   

paraList = c("theta0",
             "theta1",
             "theta2",
             "theta3",
             "a",
             "b"
)
n.iter = 100000
n.burnin = 5000
n.chains = 3
n.thin = 10

ini1=list(theta0=rnorm(1), 
          theta1=rnorm(1), 
          theta2=rnorm(1),
          theta3=rnorm(1)
) 
inits = list(ini1, ini1, ini1)

# Fit the model
Naga_jags <- jags(data = dataList,
                  model.file = "Naga_model.txt",
                  parameters.to.save = paraList,
                  n.iter = n.iter,
                  n.burnin = n.burnin,
                  n.chains = n.chains,
                  n.thin = n.thin
                  # inits = inits
)

update(Naga_jags, n.iter = 10000)

#-------------------------------------------------------------------------------
# EXAMINE CHAINS
#-------------------------------------------------------------------------------
print(Naga_jags)

library(coda)
Naga_mcmc <- as.mcmc(Naga_jags)
plot(Naga_mcmc)

library(bayesplot)
mcmc_areas(Naga_mcmc,
           pars = c("theta0", "theta1", "theta2", "theta3", "a", "b"),
           prob = 0.8, # 80% intervals
           prob_outer = 0.99, # 99%
           point_est = "mean")

mcmc_combo(Naga_mcmc)

library(CalvinBayes)
head(posterior(Naga_jags))
diag_mcmc(Naga_mcmc, par = "theta0")
plot_post(Naga_mcmc[, "theta0"], main = "theta", xlab = expression(theta))

#---------------------------------------
color_scheme_set("green")

pc_map <- mcmc_areas(Naga_mcmc,
                     pars = c("theta0", "theta1", "theta2", "theta3"),
                     prob = 0.8, # 80% intervals
                     prob_outer = 0.99, # 99%
                     point_est = "mean"
) 
pc_map <- pc_map + 
          ggtitle("PC ~ WT + TN") +
          xlab("Standardized value")
#-------------------------------------------------------------------------------

## Posterior predictive check
post_ca = CalvinBayes::posterior(Naga_jags)

# observation number
n_obs = 44

paramsDF = post_ca %>%
          slice_sample(n=200) ## get 200 random draws of posterior

paramsDF %>% head() ## see first 6 rows

paramsDF1 = select(paramsDF, theta0, theta1, theta2, theta3, a, b)


# n = 44 because n_obs = 44
simObs = function(theta0, theta1, theta2, theta3, a, b) {
          lambda = exp( theta0 +
                                  theta1 * ztemp +
                                  theta2 * zTSI +
                                  theta3 * ztemp * zTSI)
          ngis = rpois(n = 44, lambda = lambda)
          Y = rgamma(n = 44, ngis * a, b)
          return(Y)
          
}

library(tidyverse)
simsList = pmap(paramsDF1,simObs)

names(simsList) = paste0("sim",1:length(simsList))

simsDF = as_tibble(simsList)

simsDF

## create tidy version for plotting
plotDF = simsDF %>%
          pivot_longer(cols = everything()) 

## see random sample of plotDF rows
plotDF %>% slice_sample(n=10)  

obsDF = tibble(obs = srPC)

colors = c("simulated" = "cadetblue", 
           "observed" = "navyblue")

pc_ppc = ggplot(plotDF) +
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
          labs(x = "Cyanobacteria (cell/mL)",
               y = "Density Estimated from Data",
               color = "Data Type")

pc_ppc
pc_ppc + xlim(c(0,500)) +ylim(c(0,0.025))

# https://www.causact.com/posterior-predictive-checks.html#posterior-predictive-checks



#-------------------------------------------------------------------------------
# Model interpretation
summary(zip_brm1)

# parameters in original scale
exp(coef(zip_brm1))

coefs.zip.brm <- as.matrix(as.data.frame(rstan:::extract(zip_brm1$fit)))
coefs.zip.brm <- coefs.zip.brm[,grep('b', colnames(coefs.zip.brm))]
plyr:::adply(exp(coefs.zip.brm), 2, function(x) {
          data.frame(Mean=mean(x), median=median(x), HPDinterval(as.mcmc(x)))
})

marginal_effects(zip_brm1)
