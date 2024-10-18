## ---- echo=FALSE, results="hide", message=FALSE-------------------------------
require(knitr)
opts_chunk$set(error=FALSE, message=FALSE, warning=FALSE)

## ----setup, echo=FALSE, message=FALSE-----------------------------------------
library(DropletUtils)

## -----------------------------------------------------------------------------
# To generate the files.
example(write10xCounts, echo=FALSE) 
dir.name <- tmpdir
list.files(dir.name)

## -----------------------------------------------------------------------------
sce <- read10xCounts(dir.name)
sce

## -----------------------------------------------------------------------------
class(counts(sce))

## -----------------------------------------------------------------------------
set.seed(1000)
mol.info.file <- DropletUtils:::simBasicMolInfo(tempfile())
mol.info.file

## -----------------------------------------------------------------------------
mol.info <- read10xMolInfo(mol.info.file)
mol.info

## -----------------------------------------------------------------------------
set.seed(100)
no.sampling <- downsampleReads(mol.info.file, prop=1)
sum(no.sampling)
with.sampling <- downsampleReads(mol.info.file, prop=0.5)
sum(with.sampling)

## -----------------------------------------------------------------------------
set.seed(0)
my.counts <- DropletUtils:::simCounts()

## -----------------------------------------------------------------------------
br.out <- barcodeRanks(my.counts)

# Making a plot.
plot(br.out$rank, br.out$total, log="xy", xlab="Rank", ylab="Total")
o <- order(br.out$rank)
lines(br.out$rank[o], br.out$fitted[o], col="red")

abline(h=metadata(br.out)$knee, col="dodgerblue", lty=2)
abline(h=metadata(br.out)$inflection, col="forestgreen", lty=2)
legend("bottomleft", lty=2, col=c("dodgerblue", "forestgreen"), 
    legend=c("knee", "inflection"))

## -----------------------------------------------------------------------------
set.seed(100)
e.out <- emptyDrops(my.counts)
e.out

## -----------------------------------------------------------------------------
is.cell <- e.out$FDR <= 0.01
sum(is.cell, na.rm=TRUE)

## -----------------------------------------------------------------------------
table(Limited=e.out$Limited, Significant=is.cell)

## -----------------------------------------------------------------------------
plot(e.out$Total, -e.out$LogProb, col=ifelse(is.cell, "red", "black"),
    xlab="Total UMI count", ylab="-Log Probability")

## -----------------------------------------------------------------------------
set.seed(10000)

# Simulating empty droplets:
nbarcodes <- 1000
nhto <- 10
y <- matrix(rpois(nbarcodes*nhto, 20), nrow=nhto)

# Simulating cells:
ncells <- 100
true.sample <- sample(nhto, ncells, replace=TRUE)
y[cbind(true.sample, seq_len(ncells))] <- 1000

# Simulating doublets:
ndoub <- ncells/10
next.sample <- (true.sample[1:ndoub]  + 1) %% nrow(y)
next.sample[next.sample==0] <- nrow(y)
y[cbind(next.sample, seq_len(ndoub))] <- 500

## -----------------------------------------------------------------------------
hto.calls <- emptyDrops(y, lower=500)
has.cell <- hto.calls$FDR <= 0.001
summary(has.cell)

## -----------------------------------------------------------------------------
demux <- hashedDrops(y[,which(has.cell)], 
    ambient=metadata(hto.calls)$ambient)
demux

## -----------------------------------------------------------------------------
table(demux$Best[demux$Confident])

## -----------------------------------------------------------------------------
colors <- ifelse(demux$Confident, "black",
    ifelse(demux$Doublet, "red", "grey"))
plot(demux$LogFC, demux$LogFC2, col=colors,
    xlab="Log-fold change between best and second HTO",
    ylab="Log-fold change between second HTO and ambient")

## -----------------------------------------------------------------------------
set.seed(1000)
mult.mol.info <- DropletUtils:::simSwappedMolInfo(tempfile(), nsamples=3)
mult.mol.info

## -----------------------------------------------------------------------------
s.out <- swappedDrops(mult.mol.info, min.frac=0.9)
length(s.out$cleaned)
class(s.out$cleaned[[1]])

## -----------------------------------------------------------------------------
out <- chimericDrops(mult.mol.info[1])
class(out)

## -----------------------------------------------------------------------------
sessionInfo()

