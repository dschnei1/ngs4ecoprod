rm(list=ls())

# load tables 
a_fastp_table = read.table("fastp.tsv", sep="\t", header=T, comment.char = "", quote = "\"", check.names = F)
b_porechop_table = read.table("porechop_abi.tsv", sep="\t", header=T, comment.char = "", quote = "\"", check.names = F)
c_final_table = read.table("final_stats.tsv", sep="\t", header=T, comment.char = "", quote = "\"", check.names = F)

# merge tables
merged = Reduce(function(...) merge(..., all=T, by = "#Sample"), mget(ls(pattern = "_table"), .GlobalEnv))

merged[is.na(merged)] = 0

# subset tables
stats_table = data.frame(Sample = merged$`#Sample`,
                         N_sequences = formatC(merged$`#Read count (before QF)`, format="f", big.mark=",", digits=0),
                         Avg_length_bp = formatC(merged$`#Read length (before QF)`, format="f", big.mark=",", digits=0),
                         Total_Mbp = formatC(merged$`#Base pairs (before QF)`/1000000, format="f", big.mark=",", digits=0),
                         GC = paste0(round(merged$`#GC content (before QF)`*100, digits = 1),"%"),
                         N_sequences_qf = paste0(formatC(merged$`#Read count (after QF)`, format="f", big.mark=",", digits=0), " (",round(merged$`#Read count (after QF)`*100/merged$`#Read count (before QF)`,digits = 1),"%)"),
                         Avg_length_qf_bp = formatC(merged$`#Read length (after QF)`, format="f", big.mark=",", digits=0),
                         Total_qf_Mbp = paste0(formatC(merged$`#Base pairs (after QF)`/1000000, format="f", big.mark=",", digits=0), " (",round(merged$`#Base pairs (after QF)`*100/merged$`#Base pairs (before QF)`,digits = 1),"%)"),
                         GC_qf = paste0(round(merged$`#GC content (after QF)`*100, digits = 1),"%"),
                         N_forward_adapter = merged$`#Reads_forward_adapter`,
                         N_bp_removed_for = merged$`#bp_removed`,
                         N_reverse_adapter = merged$`#Read_reverse_adapter`,
                         N_bp_removed_rev = merged$`#bp_removed.1`,
                         N_reads_split = merged$`#reads_split`,
                         N_sequences_final = paste0(formatC(merged$`#Final_number_sequences`, format="f", big.mark=",", digits=0), " (",round(merged$`#Final_number_sequences`*100/merged$`#Read count (before QF)`,digits = 1),"%)"),
                         Mbp_final = paste0(formatC(merged$`#Final_bp`/1000000, format="f", big.mark=",", digits=0), " (",round(merged$`#Final_bp`*100/merged$`#Base pairs (before QF)`, digits = 1),"%)"))

names(stats_table) = gsub(x = names(stats_table), pattern = "_", replacement = " ")

# export table
write.table(stats_table, file="ngs4_np_qf_report.tsv", row.names=F, sep = "\t", quote=FALSE)
