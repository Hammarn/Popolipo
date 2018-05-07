args = commandArgs(trailingOnly=TRUE)
if (length(args)==0) {
  stop("At least one argument must be supplied (input file).n", call.=FALSE)

inputfile<-"args[1]"
WD<-getwd()
setwd (WD)
outputfile<-"all_lim_167"
library(calibrate)
data1<- read.table (inputfile, header = TRUE)
attach (data1)
data2 <- as.dist(data1)  #this gives a triangular matrix dist 2 is triangular matrix
output1<-cmdscale(data2, k = 2, eig = FALSE, add = FALSE, x.ret = FALSE)

pdf (file =paste(outputfile,"_mds.pdf", sep=""), width =10, height = 10, pointsize =12)
plot (output1[,1], output1[,2], col = "aquamarine4", pch = 20, asp = 1, xlab="Component1", ylab="Component2", main= paste("MDS off:",inputfile))
text(output1[,1], output1[,2],  rownames(output1), cex = 0.8, col = "black")
dev.off()
q()
N
