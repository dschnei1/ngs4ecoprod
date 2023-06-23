# Load libraries
library(ampvis2) # https://github.com/MadsAlbertsen/ampvis2
library(stringr)
library(ggplot2)

# Clear environment
rm(list=ls())

# Load and prepare data
myotutable = read.table("2_ASV_table_BLCA_raw.tsv", sep = "\t", header=T, check.names=F, comment.char="", skip = 0, quote = "")

# Modify data for ampvis2
# Get taxonomy from OTU table
row.names(myotutable)=myotutable$`#OTU ID`
tax_info = data.matrix(myotutable$taxonomy)
OTUID = row.names(myotutable)

# Construct a data frame from taxonomy info and separate by ;
tax_info = str_split_fixed(tax_info, '\\;',15)
tax_info = data.frame(tax_info, stringsAsFactors = FALSE)
tax_info$X15 = NULL

# Use confidence threshold of 80%
# convert columns to numeric
tax_info$X2 = as.numeric(as.character(tax_info$X2))
tax_info$X4 = as.numeric(as.character(tax_info$X4))
tax_info$X6 = as.numeric(as.character(tax_info$X6))
tax_info$X8 = as.numeric(as.character(tax_info$X8))
tax_info$X10 = as.numeric(as.character(tax_info$X10))
tax_info$X12 = as.numeric(as.character(tax_info$X12))
tax_info$X14 = as.numeric(as.character(tax_info$X14))

# apply threshold
tax_info$X1[ tax_info$X2 < 80 ] = ""
tax_info$X3[ tax_info$X4 < 80 ] = ""
tax_info$X5[ tax_info$X6 < 80 ] = ""
tax_info$X7[ tax_info$X8 < 80 ] = ""
tax_info$X9[ tax_info$X10 < 80 ] = ""
tax_info$X11[ tax_info$X12 < 80 ] = ""
tax_info$X13[ tax_info$X14 < 80 ] = ""

tax_info = data.frame(cbind(tax_info$X1,tax_info$X3,tax_info$X5,tax_info$X7,tax_info$X9,tax_info$X11,tax_info$X13))

tax_info[] = lapply(tax_info, gsub, pattern = "superkingdom:", replacement = "")
tax_info[] = lapply(tax_info, gsub, pattern = "phylum:", replacement = "")
tax_info[] = lapply(tax_info, gsub, pattern = "class:", replacement = "")
tax_info[] = lapply(tax_info, gsub, pattern = "order:", replacement = "")
tax_info[] = lapply(tax_info, gsub, pattern = "family:", replacement = "")
tax_info[] = lapply(tax_info, gsub, pattern = "genus:", replacement = "")
tax_info[] = lapply(tax_info, gsub, pattern = "species:", replacement = "")

# Add column names
colnames(tax_info) = c("Kingdom", "Phylum", "Class", "Order", "Family", "Genus", "Species")
rownames(tax_info) = OTUID

# Remove old taxonomy from OTU table
myotutable$taxonomy = NULL

# Add new taxonomy (merge both tables)
myotutable = cbind(myotutable, tax_info)
myotutable$tax_info = NULL

# Rename first column
colnames(myotutable)[1] = "OTU"

# Combine the data to ampvis2 class
dataset = amp_load(otutable = myotutable)

# Print dataset characteristics
dataset

# Export data
amp_export_otutable(dataset, "../ASV_table_BLCA_ncbi", sep = "\t", extension = "tsv")
