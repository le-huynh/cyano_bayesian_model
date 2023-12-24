#---
# func_diag.R
# 
# This Rscript:
# revise function CalvinBayes::diagMCMC()
# - customed parName
# - [sourcode](https://github.com/rpruim/CalvinBayes/blob/master/R/DBDAplots.R)
#
#---

library(CalvinBayes)

rv_diagMCMC <- function(object,
		    parName = varnames(object)[1],
		    title) {
	DBDAplColors = c("skyblue", "black", "royalblue", "steelblue")
	par(mar = 0.5+c(3, 4, 1, 0), 
	    oma = 0.1 + c(0, 0, 2, 0), 
	    mgp = c(2.25, 0.7, 0),
	    cex.lab = 1.5)
	layout(matrix(1:4, nrow = 2))
	coda::traceplot(object[, c(parName)], 
		      main = "", ylab = "Param. Value",
		      col = DBDAplColors)
	tryVal = try(
		coda::gelman.plot(object[, c(parName)], 
			        main = "", 
			        auto.layout = FALSE,
			        col = DBDAplColors)
	)
	# if it runs, gelman.plot returns a list with finite shrink values:
	if (class(tryVal) == "try-error") {
		plot.new()
		print(paste0("Warning: coda::gelman.plot fails for ", parName))
	} else {
		if (class(tryVal) == "list" & !is.finite(tryVal$shrink[1])) {
			plot.new()
			print(paste0("Warning: coda::gelman.plot fails for ", parName))
		}
	}
	DbdaAcfPlot(object, parName, plColors = DBDAplColors)
	DbdaDensPlot(object, parName, plColors = DBDAplColors)
	mtext(text = title, 
	      outer = TRUE, 
	      adj = c(0.5, 0.5), 
	      cex = 1.4)
}


