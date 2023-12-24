### POISSON for ZERO-INFLATED DATA
# link: https://www.flutterbys.com.au/stats/tut/tut10.6b.html


#-------------------------------------------------------------------------------
# Data
#-------------------------------------------------------------------------------
library(here)
Naga_data <- read.csv(here("Data","Naga_data.csv"))
View(Naga_data)
attach(Naga_data)

library(dplyr)
# Compute TSI value from Chl-a
Naga <- Naga_data %>%
          mutate(TSI_chla = 10* (6 - ((2.04 - 0.68 * log(Chl_a)) / log(2))))


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


Na_dat = data.frame(srPC, srmcyB, ztemp, zTSI, PC_r0, mcyB_r0)
#-------------------------------------------------------------------------------
# Confirm non-normality and explore clumping
#-------------------------------------------------------------------------------
hist(srPC)

boxplot(srPC, horizontal=TRUE, xlab = "Cyanobacteria (cells/mL) (square-root-transformed)")
rug(jitter(srPC), side=1)

#-------------------------------------------------------------------------------
# Confirm linearity - simple linear regression
#-------------------------------------------------------------------------------
hist(ztemp)
hist(zTSI)

plot(srPC ~ ztemp)
with(subset(dat,srPC>0), lines(lowess(srPC~ztemp)))

#-------------------------------------------------------------------------------
# Explore zero inflation
#-------------------------------------------------------------------------------
#proportion of 0's in the data
dat.tab<-table(srPC==0)
dat.tab/sum(dat.tab)





# value under FALSE is the proportion of non-zero values in the data
# value under TRUE is the proportion of zeros in the data

#proportion of 0's expected from a Poisson distribution
mu <- mean(srPC)
cnts <- rpois(1000, mu)
dat.tab <- table(cnts == 0)
dat.tab/sum(dat.tab)

#-------------------------------------------------------------------------------
# Simple Poisson regression
#-------------------------------------------------------------------------------
## Poisson GLM
M1 <- glm(srPC ~ ztemp + zTSI,
          family = 'poisson',
          data = Na_dat)

summary(M1)

## Check for over/underdispersion in the model
E2 <- resid(M1, type = "pearson")
N  <- nrow(Na_dat)
p  <- length(coef(M1))   
sum(E2^2) / (N - p)

#-------------------------------------------------------------------------------
# Negative Binomial GLM
library(MASS)
M2 <- glm.nb(srPC ~ ztemp + zTSI,
             data = Na_dat)

summary(M2)

# Dispersion statistic
E2 <- resid(M2, type = "pearson")
N  <- nrow(Na_dat)
p  <- length(coef(M2)) + 1  # '+1' is for variance parameter in NB
sum(E2^2) / (N - p)

#-------------------------------------------------------------------------------
# Zero-Inflated Poisson GLM
library(pscl)
M3 <- zeroinfl(PC_r0 ~ ztemp + zTSI | ## Predictor for the Poisson process
                         ztemp + zTSI, ## Predictor for the Bernoulli process;
               dist = 'poisson',
               data = Na_dat)

summary(M3)

# Dispersion statistic
E2 <- resid(M3, type = "pearson")
N  <- nrow(Na_dat)
p  <- length(coef(M3))  
sum(E2^2) / (N - p)

#-------------------------------------------------------------------------------
# zero-inflated negative binomial (ZINB)
M4 <- zeroinfl(PC_r0 ~ ztemp + zTSI |
                         ztemp + zTSI,
               dist = 'negbin',
               data = Na_dat)
summary(M4)

# Dispersion Statistic
E2 <- resid(M4, type = "pearson")
N  <- nrow(Na_dat)
p  <- length(coef(M4)) + 1 # '+1' is due to theta
sum(E2^2) / (N - p)