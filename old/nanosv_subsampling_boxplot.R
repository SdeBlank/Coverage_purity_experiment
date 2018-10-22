library(ggplot2)
library(reshape2)
#library(dplyr)
#library(tidyr)
args <- commandArgs(trailingOnly=TRUE)

input=args[1]
output=args[2]

coverage=strsplit(input, "_")
coverage=coverage[[1]]

table = read.table(header=T, sep='\t', input)

table = melt(table, id=c("Sample"))
table=table[-(2:10),]
table=table[-(nrow(table):(nrow(table)-8)),]


table$variable=sub("tumor", "", table$variable)
#table$value=sort(as.double(table$variable))
table$variable=paste(table$variable, "%", sep="")
table$variable=factor(table$variable, levels = unique(table$variable))


boxplot <- ggplot(table, aes(x=variable, y=value)) + geom_boxplot(outlier.shape=NA) + 
  labs(title=paste0("Recall rate of high confidence COLO829 breakpoints by NanoSV (", coverage, "x coverage)"), y="Percentage of breakpoints recalled", x="Percentage of tumour sequencing data")  +
  theme_bw()
boxplot <- boxplot + geom_jitter(height = 0, width=0.22, colour='black', size=1, fill='blue', shape=21)  + 
  #scale_y_continuous(limits = c(0,50), breaks=seq(0,50,5), labels=seq(0,50,5))
  scale_y_continuous(limits = c(0,50), breaks=seq(0,50,5), labels=paste(seq(0,100,10), '%', sep=''))
#p + geom_dotplot(binaxis="y", stackdir="center", dotsize=0.4, colour='blue', fill='blue', alpha=.5)

pdf(file=output, paper='a4r', height=12, width=16)
plot(boxplot)
dev.off()


#ctrl+shift+enter to run whole document
#ctrl+shift+c to comment/uncomment
