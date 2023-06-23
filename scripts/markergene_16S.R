# Note: Throughout the entire script OTU stands for ASV

#
# Load libraries ####
#
library(ampvis2) # https://github.com/MadsAlbertsen/ampvis2
library(phytools)
library(picante)
library(cowplot)

# Clean environment
rm(list=ls())

#
# Load and data ####
#

# Read ASV table
myotutable = read.table("ASV_table.tsv", sep = "\t", header=T, check.names=F, comment.char="", skip = 0, quote = "")
# or if you used ngs4_16S_blca/ngs4_16S_blca_ncbi
#myotutable = read.table("ASV_table_BLCA.tsv", sep = "\t", header=T, check.names=F, comment.char="", skip = 0, quote = "")
#myotutable = read.table("ASV_table_BLCA_ncbi.tsv", sep = "\t", header=T, check.names=F, comment.char="", skip = 0, quote = "")

# Fill empty cells of ASV table
myotutable[myotutable == ""] = "Unclassified"

# Read metadata
mymetadata = read.table("metadata.tsv", sep="\t", header=T, comment.char = "", quote = "\"")

# Read phylogenetic tree of ASV sequences, must be midpoint rooted!
tree = read.tree("ASV.tre")
# Midpoint root tree for unifrac
mp_tree = midpoint.root(tree)

# Read ASV sequences
ASV_seqs = ("ASV_sequences.fasta")

# Combine the data to ampvis2 class
dataset = amp_load(otutable = myotutable,
                   metadata = mymetadata,
                   tree = mp_tree,
                   fasta = ASV_seqs)

# Show general statistics
dataset

# Remove extrinsic domains
dataset = amp_subset_taxa(dataset, tax_vector=c("Eukaryota", "Chloroplast", "Mitochondria", "Archaea"), remove = T, normalise = F)
dataset

# Example heatmap ####
amp_heatmap(dataset, 
            tax_empty = "OTU",
            tax_add = "Family",
            tax_aggregate = "Genus",
            tax_class = "Proteobacteria",
            tax_show = 20,
            min_abundance = 0,
            measure = "mean",
            plot_colorscale = "sqrt",
            color_vector = c("white",rev(viridis::rocket(5, begin = 0.5, end = 1))),
            plot_values_size = 2.5,
            plot_values = T,
            round = 1,
            normalise = T) +
  theme_linedraw() +
  theme(axis.text.x = element_text(angle=90, size=10, vjust=0.25, hjust = 1),
        axis.text.y = element_text(angle=0, size=10, hjust=1),
        legend.position="right")

# Example ordination (weighted Unifrac PCoA)
amp_ordinate(dataset,
             num_threads = 1,
             type = "PCoA",
             distmeasure = "wunifrac",
             transform = "none",
             filter_species = 0,
             sample_label_by = "SampleID",       
             sample_point_size = 3,
             envfit_show = F,
             detailed_output = F)



# Diversity metrics ####
# Rarefy data
dataset
dataset_subset = amp_subset_samples(dataset, rarefy = 276, normalise = F)
dataset_subset

# Calculate alpha diversity indices
diversity = amp_alphadiv(dataset_subset, richness = TRUE)

# Calculate Faiths Phylogenetic diversity
# Thanks go to Avril von Hoyningen-Huene for implementation
faithsPD = pd(t(dataset_subset$abund), dataset_subset$tree, include.root = T)

# Combine tables
diversity = cbind(diversity, PD = faithsPD$PD)

# Loop for geom_boxplots plots
metadatalist = colnames(diversity)

# https://stackoverflow.com/questions/1816480/generating-names-iteratively-in-r-for-storing-plots
pltList = list()
for (i in 1:length(metadatalist)) 
{
  pltName = paste( metadatalist[i], sep = '' )
  pltList[[ pltName ]] = ggplot(diversity, aes_string(x="SampleID",y=metadatalist[i])) +
    geom_point(aes_string(fill="SampleID"), shape = 21, size = 3) +
    theme_linedraw() +
    labs(title=as.name(metadatalist[i]), x= "") +
    theme(plot.title = element_text(hjust = 0.5),
          legend.position = "none",
          axis.text.x = element_text(angle = 90, hjust = 1, vjust = 0.5))
}

# Show all plot names
summary(pltList)

# Plot the data of interest
plot_grid(pltList$ObservedOTUs, pltList$Shannon, pltList$PD, align = "v", nrow = 3)
