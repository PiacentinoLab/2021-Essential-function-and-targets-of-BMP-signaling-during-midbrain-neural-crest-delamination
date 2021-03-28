library(datasets)
library(ggplot2)
library(multcomp)
library(nlme)
library(XLConnect)
library(XLConnectJars)
library(lme4)
library(rJava)
library(xlsx)
library(readxl)

getwd()
aq_trim1 <- read.csv('Fig3F_GOBP_BubblePlot_Data.csv')
aq_trim1 <- aq_trim1[which(aq_trim1$GeneSet == "Downregulated" |
                            aq_trim1$GeneSet == "Upregulated"), ]
head(aq_trim1)

aq_trim1$GeneSet <- factor(aq_trim1$GeneSet, labels = c("Downregulated", "Upregulated")) 

setEPS()

postscript("dnBMPR1A_DEGs_GO_Biological_Process.eps")
p7 <- ggplot(aq_trim1, aes(x = GeneSet, y = reorder(GOBP,-pvalue), 
                size = FoldEnrichment, fill = pvalue)) +
  geom_point(shape = 21) +
  theme_bw() +
  theme()
p7 <-  p7 + scale_fill_continuous(low = "red", high = "white")
p7 <- p7 + 
  labs(x = "GeneSet", y = "Biological Process") + 
  scale_size(range = c(1, 15)) +
  theme(legend.position="right", legend.direction="vertical",
        legend.box = "vertical",
        legend.key.size = unit(0.6, "cm"))
p7
dev.off()
