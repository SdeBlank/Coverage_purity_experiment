library(ggplot2)
library(reshape2)
#library(dplyr)
#library(tidyr)
args <- commandArgs(trailingOnly=TRUE)

input=args[1]
output=args[2]

table = read.table(header=T, sep='\t', input)
table$Purity=as.integer(table$Purity)
table <- table[order(table$Purity),]

table = melt(table, id=c("Purity", "Sample"))
table$variable=sub("X", "", table$variable)
table$variable=sub("x", "", table$variable)

table$variable=factor(table$variable, levels = unique(table$variable))
table$Purity=factor(table$Purity, levels = unique(table$Purity))

shapes=c(21, 22, 23, 24, 25, 21, 22, 23, 24, 25, 21)

boxplot <- ggplot(table, aes(x=Purity, y=value))
selection=seq(0, 40, 5)

for (coverage in selection){
boxplot <- boxplot +
  stat_summary(data=table[table$variable == coverage,], aes(group=1, color=variable), fun.y=mean, geom="line")  +
  stat_summary(data=table[table$variable == coverage,], aes(shape=variable, fill=variable), fun.y=mean, geom="point", size=3.5)
}
  
boxplot <- boxplot +  
  labs(title="Recall rate of high confidence COLO829 breakpoints by NanoSV", y="Percentage of breakpoints recalled", x="Coverage")  +
  scale_y_continuous(limits = c(0,50), breaks=seq(0,50,5), labels=paste(seq(0,100,10), '%', sep='')) +
  scale_shape_manual(values=shapes, breaks=selection) +
  scale_fill_discrete(breaks=selection)+
  scale_color_discrete(breaks=selection)+
  guides(shape=guide_legend(title="Coverage", reverse=T, override.aes = list(size=4)), fill=guide_legend(title="Coverage", reverse=T), size=FALSE, color=FALSE)+
  theme_bw() 


boxplot

pdf(file=output, paper='a4r', height=12, width=16)
plot(boxplot)
dev.off()
