#!/usr/bin/env Rscript  
#plot tree and shared alleles of dataset only filtered for marker missingness
args = commandArgs(trailingOnly=TRUE)
if (length(args)==0) {
  stop("At least one argument must be supplied (input file).n", call.=FALSE)


WD<-getwd()
setwd(WD)
outputfile<-"Alleles_largedist"
largedist1a<- read.table ("args[1]", header = TRUE)
attach (largedist1a)
largedist2a <- as.dist(largedist1a)  #this gives a triangular matrix dist 2 is triangular matrix
largehca <- hclust(largedist2a, "average") #UPGMA

pdf (file =paste(outputfile,"_tree.pdf", sep=""), width =10, height = 5, pointsize =6)
plot(largehca, cex=0.8)
dev.off()
q()
N
