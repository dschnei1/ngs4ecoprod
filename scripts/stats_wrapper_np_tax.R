rm(list=ls())

# load tables 
summary = read.table("ngs4_np_tax_stats.tsv", sep="\t", header=T, comment.char = "", quote = "\"", check.names = F)



# subset tables
stats_table = data.frame(Sample = summary$Sample,
                         Classified_kraken2 = paste0(formatC(summary$`Classified (kraken2)`, format="f", big.mark=",", digits=0), " (",round(summary$`Classified (kraken2)`*100/(summary$`Classified (kraken2)`+summary$`Unclassified (kraken2)`), digits = 1),"%)"),
                         Unclassified_kraken2 = paste0(formatC(summary$`Unclassified (kraken2)`, format="f", big.mark=",", digits=0), " (",round(summary$`Unclassified (kraken2)`*100/(summary$`Classified (kraken2)`+summary$`Unclassified (kraken2)`), digits = 1),"%)"),
                         Classified_kaiju = paste0(formatC(summary$`Classified (kaiju)`, format="f", big.mark=",", digits=0), " (",round(summary$`Classified (kaiju)`*100/(summary$`Classified (kaiju)`+summary$`Unclassified (kaiju)`), digits = 1),"%)"),
                         Unclassified_kaiju = paste0(formatC(summary$`Unclassified (kaiju)`, format="f", big.mark=",", digits=0), " (",round(summary$`Unclassified (kaiju)`*100/(summary$`Classified (kaiju)`+summary$`Unclassified (kaiju)`), digits = 1),"%)"),
                         Classified_k2k = paste0(formatC(summary$`Classified (merge)`, format="f", big.mark=",", digits=0), " (",round(summary$`Classified (merge)`*100/(summary$`Classified (merge)`+summary$`Unclassified (merge)`), digits = 1),"%)"),
                         Unclassified_k2k = paste0(formatC(summary$`Unclassified (merge)`, format="f", big.mark=",", digits=0), " (",round(summary$`Unclassified (merge)`*100/(summary$`Classified (merge)`+summary$`Unclassified (merge)`), digits = 1),"%)")                         )



# export table
write.table(stats_table, file="ngs4_np_tax_report.tsv", row.names=F, sep = "\t", quote=FALSE)
