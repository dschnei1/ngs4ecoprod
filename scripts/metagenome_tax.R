#
# Load libraries ####
#
library(ampvis2)
library(stringr)

rm(list=ls())

#
# Load data ####
#

myotutable = read.table("ngs4_tax_table.tsv", sep = "\t", header=T, check.names=F, comment.char="", skip = 0, quote = "")
#mymetadata = read.table("metadata.txt", sep="\t", header=T, comment.char = "", quote = "\"")

#
# Modify data for ampvis2 ####
#

# Get taxonomy from OTU table
row.names(myotutable)=myotutable$`#OTU ID`
tax_info = data.matrix(myotutable$taxonomy)
OTUID = row.names(myotutable)
# Construct a data frame from taxonomy info and separate by ;
#tax_info=do.call(rbind, strsplit(tax_info, '\\; '))# Warning message is expected due to different depths of taxonomy
tax_info=str_split_fixed(tax_info, '\\; ',7)
# Add column names
colnames(tax_info) = c("Kingdom", "Phylum", "Class", "Order", "Family", "Genus", "Species")
#rownames(tax_info) = OTUID
# Replace empty with Unclassified
tax_info = gsub(x = tax_info, pattern = "^$|^ $", replacement = "Unclassified")
tax_info = data.frame(tax_info)
tax_info$Kingdom = gsub(x = tax_info$Kingdom, pattern = "Unclassified", replacement = "K__Unclassified")
tax_info$Kingdom = gsub(x = tax_info$Kingdom, pattern = "NA", replacement = "K__Unclassified")
tax_info$Phylum = gsub(x = tax_info$Phylum, pattern = "Unclassified", replacement = "P__Unclassified")
tax_info$Phylum = gsub(x = tax_info$Phylum, pattern = "NA", replacement = "P__Unclassified")
tax_info$Class = gsub(x = tax_info$Class, pattern = "Unclassified", replacement = "C__Unclassified")
tax_info$Class = gsub(x = tax_info$Class, pattern = "NA", replacement = "C__Unclassified")
tax_info$Order = gsub(x = tax_info$Order, pattern = "Unclassified", replacement = "O__Unclassified")
tax_info$Order = gsub(x = tax_info$Order, pattern = "NA", replacement = "O__Unclassified")
tax_info$Family = gsub(x = tax_info$Family, pattern = "Unclassified", replacement = "F__Unclassified")
tax_info$Family = gsub(x = tax_info$Family, pattern = "NA", replacement = "F__Unclassified")
tax_info$Genus = gsub(x = tax_info$Genus, pattern = "Unclassified", replacement = "G__Unclassified")
tax_info$Genus = gsub(x = tax_info$Genus, pattern = "NA", replacement = "G__Unclassified")
tax_info$Species = gsub(x = tax_info$Species, pattern = "Unclassified", replacement = "S__Unclassified")
tax_info$Species = gsub(x = tax_info$Species, pattern = "NA", replacement = "S__Unclassified")
# Remove old taxonomy from OTU table
myotutable$taxonomy = NULL
# Add new taxonomy (add dummy column for ampvis & merge both tables)
myotutable = cbind(OTU=row.names(myotutable),myotutable, tax_info)

#
# Load all data in ampvis2  ####
#

# Combine the data to ampvis2 class
dataset = amp_load(otutable = myotutable)
                   #metadata = mymetadata)

# Get some general info on your dataset
dataset

#
# Heatmaps #### 
#

amp_heatmap(amp_subset_taxa(dataset, tax_vector = c("Eukaryota","K__Unclassified"), remove = T, normalise = F), 
            #group_by = "site",
            #facet_by = c("year", "month"),
            tax_aggregate = "Family",
            tax_add =  "Phylum",
            tax_class = "Proteobacteria",
            tax_empty = "OTU",
            tax_show = 20,
            min_abundance = 0,
            plot_colorscale = "sqrt",
            color_vector = c("white",rev(viridis::rocket(4, begin = 0.4))),
            plot_values = T,
            plot_values_size = 3,
            round = 0,
            normalise = T) +
            theme_linedraw() +
            theme(axis.text.x = element_text(angle=90, size=12, vjust=0.25, hjust = 1),
            axis.text.y = element_text(angle=0, size=12, hjust=1),
            legend.position="right")

#
# Ordination  ####
#

# NMDS
amp_ordinate(dataset,
              type = "NMDS",
              distmeasure = "bray",
              transform = "none",
              filter_species = 0,
              sample_label_by = "SampleID",
              sample_label_size = 3,
              #sample_colorframe = T,
              sample_point_size = 3,
              #sample_colorframe_label = "site",
              #sample_plotly = T,
              detailed_output = F)
