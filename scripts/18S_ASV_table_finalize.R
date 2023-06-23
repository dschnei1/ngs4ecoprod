# Load libraries
library(ampvis2) # https://github.com/MadsAlbertsen/ampvis2
library(stringr)
library(ggplot2)

# Clear environment
rm(list=ls())

# Load and prepare data
myotutable = read.table("1_ASV_table.tsv", sep = "\t", header=T, check.names=F, comment.char="", skip = 0, quote = "")

# Modify data for ampvis2
# Get taxonomy from OTU table
row.names(myotutable)=myotutable$`#OTU ID`
tax_info = data.matrix(myotutable$taxonomy)
OTUID = row.names(myotutable)

# Construct a data frame from taxonomy info and separate by ;
tax_info = str_split_fixed(tax_info, '\\~',5)
tax_info = gsub(x = tax_info, pattern = "^$", replacement = "0")
tax_info = data.frame(tax_info, stringsAsFactors = F)
tax_info$X3 = as.numeric(tax_info$X3)
tax_info$X4 = as.numeric(tax_info$X4)

# Correct for coverage (at least 85% coverage query to subject)
tax_info$X1[ tax_info$X4 < 85 ] = "No blast hit"
tax_info = data.frame(cbind(tax_info$X3,tax_info$X1), stringsAsFactors = F)
tax_info = cbind(tax_info$X1, str_split_fixed(tax_info$X2, '\\;',7))
tax_info = gsub(x = tax_info, pattern = "~.*", replacement = "")
tax_info = gsub(x = tax_info, pattern = "^$", replacement = "unclassified")
tax_info = gsub(x = tax_info, pattern = "_", replacement = " ")
tax_info = data.frame(tax_info, stringsAsFactors = F)
tax_info$X1 = as.numeric(tax_info$X1)

# Apply all Yarza thresholds (<98.7 Species, <94.5 Genus,<86.5 Family, <82.0 Order, <78.5 Class, <75 Phylum)
# See: https://www.nature.com/articles/nrmicro3330
# Species
tax_info$X8[ tax_info$X1 < 98.7 ] = "Unclassified"
# Genus
tax_info$X7[ tax_info$X1 < 94.5 ] = "Unclassified"
# Family
tax_info$X6[ tax_info$X1 < 86.5 ] = "Unclassified"
# Order
tax_info$X5[ tax_info$X1 < 82.0 ] = "Unclassified"
# Class
tax_info$X4[ tax_info$X1 < 78.5 ] = "Unclassified"
# Phylum
tax_info$X3[ tax_info$X1 < 75.0 ] = "Unclassified"
# Remove blast percent identity column
tax_info$X1 = NULL

# Clean up taxonomy
tax_info[] = lapply(tax_info, gsub, pattern = "unclassified", replacement = "Unclassified")
tax_info[] = lapply(tax_info, gsub, pattern = "^$", replacement = "Unclassified")
tax_info[] = lapply(tax_info, gsub, pattern = "uncultured organism", replacement = "Unclassified")
tax_info[] = lapply(tax_info, gsub, pattern = "uncultured", replacement = "Unclassified")
tax_info[] = lapply(tax_info, gsub, pattern = "uncultured.*bacterium", replacement = "Unclassified")
tax_info[] = lapply(tax_info, gsub, pattern = "uncultured bacterium.*", replacement = "Unclassified")
tax_info[] = lapply(tax_info, gsub, pattern = "unidentified.*bacterium", replacement = "Unclassified")
tax_info[] = lapply(tax_info, gsub, pattern = "unidentified bacterium.*", replacement = "Unclassified")
tax_info[] = lapply(tax_info, gsub, pattern = ".*metagenome.*", replacement = "Unclassified")
tax_info[] = lapply(tax_info, gsub, pattern = "^ ", replacement = "")
tax_info$X2 = gsub(x = tax_info$X2, pattern = "Unclassified", replacement = NA)
tax_info$X3 = gsub(x = tax_info$X3, pattern = "Unclassified", replacement = NA)
tax_info$X4 = gsub(x = tax_info$X4, pattern = "Unclassified", replacement = NA)
tax_info$X5 = gsub(x = tax_info$X5, pattern = "Unclassified", replacement = NA)
tax_info$X6 = gsub(x = tax_info$X6, pattern = "Unclassified", replacement = NA)
tax_info$X7 = gsub(x = tax_info$X7, pattern = "Unclassified", replacement = NA)
tax_info$X8 = gsub(x = tax_info$X8, pattern = "Unclassified", replacement = NA)

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
amp_export_otutable(dataset, "../ASV_table", sep = "\t", extension = "tsv")
write.table(dataset$metadata, file = "../metadata.tsv", sep = "\t", row.names = F)
