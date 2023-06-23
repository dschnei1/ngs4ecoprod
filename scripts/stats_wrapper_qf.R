rm(list=ls())

# load tables 
a_fastp_table = read.table("fastp.tsv", sep="\t", header=T, comment.char = "", quote = "\"", check.names = F)
b_cutadapt_table = read.table("cutadapt.tsv", sep="\t", header=T, comment.char = "", quote = "\"", check.names = F)
c_bowtie2_table = read.table("bowtie2.tsv", sep="\t", header=T, comment.char = "", quote = "\"", check.names = F)
d_final_table = read.table("final_stats.tsv", sep="\t", header=T, comment.char = "", quote = "\"", check.names = F)

# merge tables
merged = Reduce(function(...) merge(..., all=F, by = "#Sample"), mget(ls(pattern = "_table"), .GlobalEnv))

# subset tables
stats_table = data.frame(Sample = merged$`#Sample`,
                         sequences = formatC(merged$`#Read count (before QF)`, format="f", big.mark=",", digits=0),
                         bp = formatC(merged$`#Base pairs (before QF)`, format="f", big.mark=",", digits=0),
                         GC = paste0(round(merged$`#GC content (before QF)`*100, digits = 1),"%"),
                         sequences_qf = paste0(formatC(merged$`#Read count (after QF)`, format="f", big.mark=",", digits=0), " (",round(merged$`#Read count (after QF)`*100/merged$`#Read count (before QF)`,digits = 1),"%)"),
                         bp_qf = paste0(formatC(merged$`#Base pairs (after QF)`, format="f", big.mark=",", digits=0), " (",round(merged$`#Base pairs (after QF)`*100/merged$`#Base pairs (before QF)`,digits = 1),"%)"),
                         GC_qf = paste0(round(merged$`#GC content (after QF)`*100, digits = 1),"%"),
                         R1_w_adapter = paste0(formatC(as.numeric(gsub(x = merged$`#forward_read_adapter`, pattern = " \\(.*", replacement = "")), format="f", big.mark=",", digits=0), " ", gsub(x = merged$`#forward_read_adapter`, pattern = ".* ", replacement = "")),
                         R2_w_adapter = paste0(formatC(as.numeric(gsub(x = merged$`#reverse_read_adapter`, pattern = " \\(.*", replacement = "")), format="f", big.mark=",", digits=0), " ", gsub(x = merged$`#reverse_read_adapter`, pattern = ".* ", replacement = "")),
                         phiX = merged$`#%phiX`,
                         sequences_final = paste0(formatC(merged$`#Final_number_sequences`, format="f", big.mark=",", digits=0), " (",round(merged$`#Final_number_sequences`*100/merged$`#Read count (before QF)`,digits = 1),"%)"),
                         bp_final = paste0(formatC(merged$`#Final_bp`, format="f", big.mark=",", digits=0), " (",round(merged$`#Final_bp`*100/merged$`#Base pairs (before QF)`, digits = 1),"%)"))

# export table
write.table(stats_table, file="ngs4_qf_report.tsv", row.names=F, sep = "\t", quote=FALSE)
