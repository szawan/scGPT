## ---- echo=FALSE, results="hide", message=FALSE-------------------------------
require(knitr)
opts_chunk$set(error=FALSE, message=FALSE, warning=FALSE)
library(BiocStyle)

## -----------------------------------------------------------------------------
library(metapod)
p1 <- rbeta(10000, 0.5, 1)
p2 <- rbeta(10000, 0.5, 1)
par.combined <- parallelSimes(list(p1, p2))
str(par.combined)

## -----------------------------------------------------------------------------
p <- rbeta(10000, 0.5, 1)
g <- sample(100, length(p), replace=TRUE)
gr.combined <- groupedSimes(p, g)
str(gr.combined)

## -----------------------------------------------------------------------------
logfc1 <- rnorm(10000)
logfc2 <- rnorm(10000)

par.dir <- summarizeParallelDirection(list(logfc1, logfc2), 
    influential = par.combined$influential)
table(par.dir)

## -----------------------------------------------------------------------------
par.dir2 <- countParallelDirection(list(p1, p2), list(logfc1, logfc2)) 
str(par.dir2)

## -----------------------------------------------------------------------------
gr.combined2 <- combineGroupedPValues(p, g, method="holm-min")
str(gr.combined2)

## -----------------------------------------------------------------------------
sessionInfo()

