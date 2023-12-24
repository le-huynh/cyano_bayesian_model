library(ggformula)       # creating plots
theme_set(theme_bw())    # change the default graphics settings
library(dplyr)           # data wrangling
library(mosaic)          
library(CalvinBayes)     
library(brms)            
library(bayesplot)
library(R2jags)
library(here)
library(coda)
library(tidyr)

#-------------------------------------------------------------------------------
# THE DATA
#-------------------------------------------------------------------------------
library(here)
Naga_data <- read.csv(here("Data","Naga_data.csv"))
View(Naga_data)
attach(Naga_data)

library(dplyr)
Naga_data <- 
          Naga_data %>%
          mutate(TSI_chla = 10 * (6 - ((2.04 - 0.68 * log(Chl_a)) / log(2)))) %>%
          mutate(TSI_chla2 = 9.81 * log(Chl_a) + 30.6) %>%
          mutate(TSI_TP = 10* (6 - (log(48/TP) / log(2)))) %>%
          mutate(TSI_TP2 = 10* (6 - (log(48/(TP*1000)) / log(2)))) %>%
          mutate(TSI_TP3 = 14.42 * log(TP) + 4.15) %>%
          mutate(TSI_TP4 = 18.6 * (log(TP * 1000)) - 18.4) %>%
          mutate(TSI_TN = 54.45 + 14.43 * log(TN))
#          mutate(Eu_State = ifelse(TSI < 40,
#                                   "Oligotrophic", 
#                                   ifelse((40 <= TSI) & (TSI <= 50)),
#                                          "Mesotrophic",
#                                          if(TSI > 50) {"Mesotrophic"}
#                                   ))

library(tidyr)
# PC - mcyB data: round () --> replace_na(0) --> scale() -> model -> transform
PC_r0 = ifelse (Naga_data$PC < 1, 0, round(Naga_data$PC)) %>%
          replace_na(0) # %>%
          # log10() %>%
          # scale()
mcyB_r0 = ifelse (Naga_data$mcyB < 1, 0, round(Naga_data$mcyB)) %>%
          replace_na(0) # %>%
          # log10() %>%
          # scale()
# zTemp = scale(Naga_data$Air_Temp)
# zTSI = scale(Naga_data$TSI)

Y = PC_r0
Y = mcyB_r0
Temp = Naga_data$Air_Temp
TSI = Naga_data$TSI

### STANDARDIZE DATA in R
### log(data) --> standardize


#Ly_scale <- function(x) {
#          xm = mean(x)
#          xsd = sd(x)
#          zx = (x - xm) / xsd
#          }
#Z_PC = Ly_scale(log_Naga_df$Y_PC)
#z_mcyB = Ly_scale(log_Naga_df$Y_mcyB)
#z_Temp = Ly_scale(log_Naga_df$Temp)
#z_TSI = Ly_scale(log_Naga_df$TSI)


#z_xyzk <- 
#     for (j in 1:dim(xyzk)[2] ) {
#                   xm[j] <- mean(xyzk[,j]) 
#                   xsd[j] <- sd(xyzk[,j])
#                   for(i in 1:dim(xyzk)[1]) {
#                              zx[i,j] <- (xyzk[i,j] - xm[j]) / xsd[j]
#                    }
#          }

# identify absence and presence
abs <- which(Y == 0)
n_abs <- length(abs)
pres <- which(Y > 0)
n_pres <- length(pres)

dataList <- list(Y = Y,
                 Temp = Temp,
                 TSI = TSI,
                 n_obs = length(Y),
                 abs = abs, 
                 n_abs = n_abs,
                 pres = pres, 
                 n_pres = n_pres)

#-------------------------------------------------------------------------------
# THE MODEL
#-------------------------------------------------------------------------------
#' `R2jags package` -> specify the model by creating a special kind of function
#' -> avoid creating temporaty .txt file
# Naga_CPG_model <- function() {

Naga_CPG_model = function() {

          ### Covariates
          for (s in 1:n_obs){
                    log(lambda[s]) <- theta0 +
                              theta1 * Temp[s] +
                              theta2 * (Temp[s] ^ 2) +
                              theta3 * TSI[s] +
                              theta4 * Temp[s] * TSI[s] # +
                              # eta_ij +
                              # nu_ik +
                              # epsilon_ijk
                    
          }
          
          ### Observation model
          # Strictly positive Observation
          for ( s in 1:n_pres){
                    N[s] ~ dpois(lambda[pres[s]]) # T(1,)
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
          theta0 ~ dnorm(0,100) 
          theta1 ~ dnorm(0,100) 
          theta2 ~ dnorm(0,100)
          theta3 ~ dnorm(0,100)
          theta4 ~ dnorm(0,100) 
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

# writeLines(Naga_CPG_model, con="Naga_model.txt" )
#-------------------------------------------------------------------------------
# INITIALIZE CHAIN
# Let JAGS do it automatically...

#-------------------------------------------------------------------------------
# GENERATE CHAIN
#-------------------------------------------------------------------------------
library(R2jags)

# Make the same "random" choices each time this is run.
# This makes the Rmd file stable so you can comment on specific results.
set.seed(1234)   

paraList = c("theta0",
             "theta1",
             "theta2",
             "theta3",
             "theta4"
             )
n.iter = 50000
n.burnin = 5000
n.chains = 3
n.thin = 2

ini1=list(theta0=rnorm(1), 
          theta1=rnorm(1), 
          theta2=rnorm(1),
          theta3=rnorm(1),
          theta4=rnorm(1)
          ) 


inits = list(ini1, ini1, ini1)
# Fit the model
Naga_jags <- jags(data = dataList,
                  model.file = Naga_CPG_model,
                  parameters.to.save = paraList
                  # n.iter = n.iter,
                  # n.burnin = n.burnin,
                  # n.chains = n.chains,
                  # n.thin = n.thin,
                  # inits = inits
          )

update(Naga_jags, n.iter = 10000)

#-------------------------------------------------------------------------------
# EXAMINE CHAINS
#-------------------------------------------------------------------------------
library(coda)
Naga_mcmc <- as.mcmc(Naga_jags)
plot(Naga_mcmc)

library(bayesplot)
mcmc_areas(Naga_mcmc)
mcmc_combo(Naga_mcmc)

library(CalvinBayes)
head(posterior(Naga_jags))
diag_mcmc(Naga_mcmc)
plot_post(Naga_mcmc[, "theta0"], main = "theta", xlab = expression(theta))



# Standardize data in JAGS   
#    data {
#          ym <- mean(Y)
#          ysd <- sd(Y)
#          for (i in 1:n_obs) { # n_obs is number of data rows
#                    zy[i] <- (y[i] - ym) / ysd
#          }
#          for (j in 1:Nx) { # Nx is number of x predictors
#                    xm[j] <- mean(x[,j]) # x: a matrix, each column a predictor
#                    xsd[j] <- sd(x[,j])
#                    for (i in n_obs) {
#                              zx[i,j] <- (x[i,j] - xm[j]) / xsd[j]
#                    }
#
#          }
#    }



gf_point(theta3 ~ theta1, data = posterior(Naga_jags), alpha = 0.05) %>%
          +     gf_density2d(theta3 ~ theta1, data = posterior(Naga_jags))

#-------------------------------------------------------------------------------
# POSTERIOR PREDICTIVE CHECK
# (Re)DBDA-chap17.4

Naga_fit = data.frame(PC_r0, Naga$Air_Temp, Naga$TSI_chla)

library(CalvinBayes)
y_ind = 
posterior_calc(Naga_jags,
          PC_r0 ~ exp(theta0 + 
                    theta1*Naga.Air_Temp + 
                    theta2*Naga.TSI_chla +
                    theta3*Naga.Air_Temp*Naga.TSI_chla),
          data = Naga_fit)