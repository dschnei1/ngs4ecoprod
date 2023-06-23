# dschnei1@gwdg.de
rm(list=ls())

# Read tables
filelist = list.files(pattern="*_summary.tsv")

for (i in 1:length(filelist))
{
  A=read.table(file=(filelist[i]), sep = "\t", header=T, quote = "", check.names = T)
  A$SampleID=(filelist[i])
  A$SampleID = gsub(x = A$SampleID, pattern = "_summary\\.tsv", replacement = "")
  names(A) = gsub(x = names(A), pattern = "\\.", replacement = "_")
  A = A[,c(10, 1:9)]
  assign(filelist[i], A)
  rm(list="A")
}

# merge tables
merged = Reduce(function(...) merge(..., all=TRUE, by = c("SampleID","BinID","Completeness","Contamination","Strain_heterogeneity","GenomeSize_bp_","N_Contig","N50_bp_","GC","GTDB_Taxa")), mget(ls(pattern = "_summary.tsv"), .GlobalEnv))
rm(list=filelist)

# modify table
stats_table = data.frame(Sample = merged$SampleID,
                         Bin_ID = merged$BinID,
                         Completeness = merged$Completeness,
                         Contamination = merged$Contamination,
                         Heterogeneity = merged$Strain_heterogeneity,
                         Size_Mbp = formatC(merged$GenomeSize_bp_/1000000, format="f", big.mark=",", digits=3),
                         Contigs = merged$N_Contig,
                         N50_Mbp = formatC(merged$N50_bp_/1000000, format="f", big.mark=",", digits=3),
                         GC = formatC(merged$GC*100, format="f", big.mark=",", digits=1),
                         GTDBtk = merged$GTDB_Taxa)

names(stats_table) = gsub(x = names(stats_table), pattern = "_", replacement = " ")
stats_table$GTDBtk = gsub(x = stats_table$GTDBtk, pattern = "d__|p__|c__|o__|f__|g__|s__", replacement = " ")

# export table
write.table(stats_table, file="ngs4_np_assembly_report.tsv", row.names=F, sep = "\t", quote=FALSE)
