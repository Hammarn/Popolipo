#!/bin/bash
## Takes a .genome file from PLINK as ARGV 1 and outputs a 

sed  "s/  / /g" $1 | sed  "s/  / /g" | sed  "s/  / /g" | sed  "s/  / /g" |  sed  "s/^ //g" | sed  "s/ /\t/g" > genome_sorted_IBS
awk '{print $10}' genome_sorted_IBS > IBSvalues
rm genome_sorted_IBS 


R
data1<- read.table ("IBSvalues", header = T)
data2<-sort(data1$PI_HAT, decreasing = TRUE)

plot(data2, cex=0.8, pch = 20, col="aquamarine4")
title("IBS_proportion")
dev2bitmap("IBS_proportion.pdf", type="pdfwrite")
q()
N
