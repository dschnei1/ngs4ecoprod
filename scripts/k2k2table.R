
# dschnei1@gwdg.de
rm(list=ls())

# Read tables
filelist = list.files(pattern="*.tax_table")

for (i in 1:length(filelist))
{
  A=read.table(file=(filelist[i]), sep = "\t", stringsAsFactors=F, header=F, fill=T, quote = "", col.names = c("Classification", "Read", "Taxon_number", "taxonomy"))
  B=data.frame(table(A$taxonomy))
  colnames(B) = c("taxonomy", (filelist[i]))
  B[] = lapply(B, gsub, pattern = "^$", replacement = "Unclassified")
  B[,2] = sapply(B[,2], as.numeric)
  assign(filelist[i], B)
  rm(list="A", "B")
}

# merge tables
merged = Reduce(function(...) merge(..., all=TRUE, by = "taxonomy"), mget(ls(pattern = ".tax_table"), .GlobalEnv))

# Replace NA's by 0
merged[is.na(merged)] = 0
names(merged) = gsub(x = names(merged), pattern = ".tax_table", replacement = "")

# Export table
write.table(merged, file="ngs4_tax_table.tsv", row.names=F, sep = "\t", quote=FALSE)
