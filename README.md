Early release v0.1

# NGS-4-ECOPROD wrapper/pipeline collection
NGS-4-ECOPROD wrapper/pipeline collection is primarily dedicated to metagenome data processing and analysis. It aims to simplify the often complex and labor-intensive tasks associated with this kind of data by automating key steps in the processing of raw sequence data to human interpretable data. The pipeline provides basic analysis scripts and tools from the public domain. The overarching goal is to optimize time utilization by streamlining data workflows, allowing researchers to devote more time to the substantive biological analysis.

This repository is developed in the framework of [NGS-4-ECOPROD](https://cordis.europa.eu/project/id/101079425) at the University of Göttingen. The pipeline aims to automate and simplify metagenomic workflows (including 16S/18S rRNA gene amplicon anaylsis, metagenomes derived from Illumina paired-end sequencing, metagenomes derived from Nanopore long-reads etc.).

The pipeline was tested under Linux (Ubuntu 12.04 LTS, 20.04, 22.04 LTS) and is encapsuled in a (mini)conda environment with the to not affect the linux operating system it is installed on and it can be removed at any time.

# Table of contents
1. [Installation](#installation)
2. [Install databases](#install-databases)
3. [Uninstall NGS-4-ECOPROD](#uninstall-ngs-4-ecoprod)
4. [Usage](#usage)
5. [Author](#author)
6. [Citation](#citation)
#

# Installation 

You can either install the pipeline as a [user](#user-installation-local) into your home or as server [admin](#admin-installation-system-wide) in - for example - `/opt` and make it accessable for every user via an alias in the users `.bashrc` or corresponding shell.

The current disk space requirement for the installation is approximately 23 GB without the databases. However, when including all databases needed, the total disk space needed increases to roughly 1 TB, with SILVA requiring an additional 1 GB, kraken2 database (nt) requiring 676 GB, kaiju database (nr) requiring 187 GB, and GTDB-Tk & PLSDB requiring 80 GB.

### User installation, local

```
# 1. Download install_ngs4ecoprod bash installation script
curl -H 'Authorization: token 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' -H 'Accept: application/vnd.github.v3.raw' -O -L https://api.github.com/repos/dschnei1/ngs4ecoprod/contents/install_ngs4ecoprod
#wget https://raw.githubusercontent.com/dschnei1/ngs4ecoprod/main/install_ngs4ecoprod

# 2. Install ngs4ecoprod (in this example into your home ~/ngs4ecoprod)
bash install_ngs4ecoprod -i ~/ngs4ecoprod

# 3. Restart terminal or type
source ~/.bashrc

# 4. Activate environment
activate_ngs4ecoprod

# 5. Remove installer
rm -f install_ngs4ecoprod
```



### Admin installation, system wide

```
# 1. Download install_ngs4ecoprod bash installation script
curl -H 'Authorization: token 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' -H 'Accept: application/vnd.github.v3.raw' -O -L https://api.github.com/repos/dschnei1/ngs4ecoprod/contents/install_ngs4ecoprod
#wget https://raw.githubusercontent.com/dschnei1/ngs4ecoprod/main/install_ngs4ecoprod

# 2. Install ngs4ecoprod (in this example into your home ~/ngs4ecoprod)
sudo bash install_ngs4ecoprod -i /opt/ngs4ecoprod

# 3. To activate the environment ensure every user has the following alias in .bashrc: 
# alias activate_ngs4ecoprod='source /opt/ngs4ecoprod/bin/activate ngs-4-ecoprod'
# Example command
echo "alias activate_ngs4ecoprod='source /opt/ngs4ecoprod/bin/activate ngs-4-ecoprod'" >> ~/.bashrc

# 4. Restart terminal or type
source ~/.bashrc

# 5. Activate environment
activate_ngs4ecoprod

# 6. Remove installer
rm -f install_ngs4ecoprod
```

#### NOTE: Before first use please run GNU parallel once after activating your conda environment and agree to conditions to cite or pay [GNU parallel](https://www.gnu.org/software/parallel/)
```
parallel --citation
```

Here is a [list](software.txt) of all software installed by `install_ngs4ecoprod` via conda, in addition [NanoPhase](https://github.com/Hydro3639/NanoPhase), [metaWRAP](https://github.com/bxlab/metaWRAP), [GTDB-tk](https://github.com/Ecogenomics/GTDBTk), [BLCA](https://github.com/qunfengdong/BLCA), [sra-toolkit](https://github.com/ncbi/sra-tools) are installed alongside.
#

# Install databases

Silva database for `ngs4_16S` & `ngs4_16S_blca` & `ngs4_18S`
```
ngs4_download_silva_db -i ~/ngs4ecoprod/ngs4ecoprod/db
```

Databases for `ngs4_np_assembly`
```
#ngs4_download_nanophase -i ~/ngs4ecoprod/ngs4ecoprod/db
```

kraken2 and kaiju databases for `ngs4_tax` & `ngs4_np_tax`
```
#download_tax_k2k
```
#

# Uninstall NGS-4-ECOPROD
To remove the pipeline do the following (adapt .bashrc to your shell)
```
# 1. Remove conda folder
rm -rf ~/ngs4ecoprod

# 2. Remove alias from .bashrc
sed -i -E "/^alias activate_ngs4ecoprod=.*/d" ~/.bashrc
```
#


# Usage
So far the repository contains the following data processing scripts:

1. [Amplicon analysis pipeline (16S rRNA gene, bacteria and archaea, 18S rRNA gene Eukaryota)](#1-1-amplicon-analysis-pipeline-16S-bacteria-and-archaea) \
`ngs4_16S` \
`ngs4_16S_blca` \
`ngs4_16S_blca_ncbi` \
`ngs4_18S` \
`ngs4_18S_blca`

2. Under development! [Nanopore: Metagenome analysis](#2-metagenomics-with-nanopore-data) \
`ngs4_np_qf` \
`ngs4_np_tax` \
`ngs4_np_assembly`

3. Under development! [Illumina: Metagenome analysis](#3-metagenomics-with-illumina-data) \
`ngs4_qf` \
`ngs4_tax`
#

### 1.1 Amplicon analysis pipeline (16S, bacteria and archaea)

![16S rRNA gene amplicon pipeline](images/16S_workflow.png)

#### Bacterial/archaeal 16S rRNA gene amplicon data processing pipeline

`ngs4_16S` is a 16S rRNA gene amplicon analysis pipeline providing processing of raw reads to amplicon sequence variant (ASV) sequences, read count table and a phylogenetic tree of ASV sequences. The default configuration of the pipeline is for Illumina MiSeq paired-end reads using reagent kit v3 (2x 300 bp, 600 cycles) with the primer pair SD-Bact-0341-b-S-17 and S-D-Bact-0785-a-A-21 proposed by [Klindworth et al. (2013)](https://doi.org/10.1093/nar/gks808). The script also performs a lineage correction (removing uncertain assignments from species to phylum based on percent identity: <98.7 species, <94.5 genus, <86.5 family, <82.0 order, <78.5 class, <75 phylum) as proposed by [Yarza et al. (2014)](https://www.nature.com/articles/nrmicro3330) to avoid over/misinterpretation of the classification by blast. However, by changing the parameters of primer sequence, sequence length, ASV length this pipeline can be used for any overlapping paired-end bacterial or archaeal amplicon raw sequence data (see [options](#options-for-ngs4_16S)).

A very basic R script (based on [ampvis2](https://github.com/KasperSkytte/ampvis2)) is provided to start your analyses. I highly recommend to fill the metadata file (metadata.tsv) with all information about the samples that you have at hand. For more information, [microsud](https://github.com/microsud) has compiled an extensive overview of available microbiome analysis [tools](https://microsud.github.io/Tools-Microbiome-Analysis/).



Before you start you need demultiplexed forward and reverse paired-end reads, placed in one folder, and sample names must meet the following naming convention:
```
<Sample_name>_<forward=R1_or_reverse=R2>.fastq.gz

# Example
Sample_1_R1.fastq.gz
Sample_1_R2.fastq.gz
Sample_2_R1.fastq.gz
Sample_2_R2.fastq.gz
...
```

Afterwards you can start the pipeline (here with example data) to process your 16S rRNA gene amplicon data.

#### Run `ngs4_16S` on your data

```
ngs4_16S \
-i ~/ngs4ecoprod/ngs4ecoprod/example_data/16S \
-o ~/ngs4_16S \
-d ~/ngs4ecoprod/ngs4ecoprod/db/silva \
-p 3 -t 8
```

#### Options for `ngs4_16S`
```
         -i     Input folder containing paired-end fastq.gz
                Note: files must be named according to the following scheme
                Sample_name_R1.fastq.gz
                Sample_name_R2.fastq.gz
         -o     Output folder
         -d     Path to silva database
         -l     Optional: Minimum length of forward and reverse sequence in bp [default: 200]
         -q     Optional: Minimum phred score [default: 20]
         -p     Number of processes [default: 1]
         -t     Number of CPU threads per process [default: 1]
         -f     Forward primer [default: CCTACGGGNGGCWGCAG]
         -r     Reverse primer [default: GGATTAGATACCCBDGTAGTC]
                Note: Use the reverse complement sequence of your 16S rRNA gene reverse primer
         -a     Optional: Minimum length of amplicon [default: 400]
         -u     Optional: minsize of UNOISE [default: 8]
                Note: Only change under special circumstances, i.e., very low sample number
         -h     Print this help
```

#### Taxonomy assignment via BLCA using Silva or NCBIs 16S rRNA gene database

Optional: Since `ngs4_16S` is using a "simple" blastn (megablast) to infer taxonomy of the ASVs you might want to use a more sophisticated approach for taxonomic assignment. You can use bayesian-based lowest common ancestor [(BLCA)](https://github.com/qunfengdong/BLCA) classification method on your data. This will take more computation time (depending on the diversity/amount of ASVs of your samples) mainly due to BLCA performing a blastn and a clustalo alignment of the ASV sequences.

There are two scripts: `ngs4_16S_blca` which is BLCA with the SILVA 138.1 database and `ngs4_16S_blca_ncbi` which is BLCA against NCBIs 16S rRNA database (Note: the database will be downloaded and taxonomy will be compiled every time you run the script).

To run BLCA with SILVA on your data after `ngs4_16S` has finished, process your data with `ngs4_16S_blca` as follows:

```
ngs4_16S_blca \
-i ~/ngs4_16S \
-d ~/ngs4ecoprod/ngs4ecoprod/db/silva \
-p 3 -t 8
```

To run BLCA with NCBIs 16S rRNA gene database on your data after `ngs4_16S` has finished, process your data with `ngs4_16S_blca_ncbi` (Note: every time you start the script the most recent version of the database will be downloaded) as follows:

```
ngs4_16S_blca -i ~/ngs4_16S -p 3 -t 8
```

#### Output

#### `ngs4_16S`

`ASV_sequences.fasta`         FAST file containing all ASVs from your dataset \
`ASV_table.tsv`               ASV read count table including blast classification \
`ASV.tre`                     Phylogenetic tree of the ASV sequences \
`markergene_16S.R`            Basic R-script to visualize and analyze your data \
`metadata.tsv`                Template metadata file including SampleID \
`ngs4_16S_DATE_TIME.log`      Pipeline log file

#### `ngs4_16S_blca`

`ASV_table_BLCA.tsv`          ASV read count table including BLCA SILVA classification \
`ngs4_16S_blca_DATE_TIME.log` Pipeline log file

#### `ngs4_16S_blca_ncbi`

`ASV_table_BLCA_ncbi.tsv`          ASV read count table including BLCA NCBI classification \
`ngs4_16S_blca_ncbi_DATE_TIME.log` Pipeline log file
#



### 1.2 Amplicon analysis pipeline (18S, Eukaryotes)

This pipeline can be used for 18S rRNA gene amplicons and is very similar to the 16S rRNA gene pipeline. Defaults are currently set to match the primer pair TAReuk454FWD1 and TAReukREV3 designed by [Stoeck et al. (2015)](https://onlinelibrary.wiley.com/doi/10.1111/j.1365-294X.2009.04480.x).

#### Run `ngs4_18S` on your data

```
ngs4_18S \
-i ~/raw_18S_data \
-o ~/ngs4_18S \
-d ~/ngs4ecoprod/ngs4ecoprod/db/silva \
-p 3 -t 8
```

#### Options for `ngs4_18S`
```
         -i     Input folder containing paired-end fastq.gz
                Note: files must be named according to the following scheme
                Sample_name_R1.fastq.gz
                Sample_name_R2.fastq.gz
         -o     Output folder
         -d     Path to silva database
         -l     Optional: Minimum length of forward and reverse sequence in bp [default: 200]
         -q     Optional: Minimum phred score [default: 20]
         -p     Number of processes [default: 1]
         -t     Number of CPU threads per process [default: 1]
         -f     Optional: Forward primer [default: CCAGCASCYGCGGTAATTCC]
         -r     Optional: Reverse primer [default: TYRATCAAGAACGAAAGT]
                Note: Use the reverse complement sequence of your 18S rRNA gene reverse primer
         -a     Optional: Minimum length of amplicon [default: 350]
         -u     Optional: minsize parameter of UNOISE [default: 8]
                Note: Only change under special circumstances, i.e., very low sample number
         -h     Print this help
```

#### Taxonomy assignment via BLCA using Silva database

```
ngs4_18S_blca \
-i ~/ngs4_18S \
-d ~/ngs4ecoprod/ngs4ecoprod/db/silva \
-p 3 -t 8
```

#### `ngs4_18S`

`ASV_sequences.fasta`         FAST file containing all ASVs from your dataset \
`ASV_table.tsv`               ASV read count table including blast classification \
`ASV.tre`                     Phylogenetic tree of the ASV sequences \
`markergene_16S.R`            Basic R-script to visualize and analyze your data \
`metadata.tsv`                Template metadata file including SampleID \
`ngs4_18S_DATE_TIME.log`      Pipeline log file

#### `ngs4_16S_blca`

`ASV_table_BLCA.tsv`          ASV read count table including BLCA SILVA classification \
`ngs4_18S_blca_DATE_TIME.log` Pipeline log file



### 2. Metagenomics with Nanopore data

![Nanopore pipeline](images/Nanopore_workflow.png)

#### 1. Quality filter long-read data

To ensure high quality long-reads, the first step is filtering your data with `ngs_np_qf` which includes a general quality filter with [fastp](https://github.com/OpenGene/fastp) and afterwards removal of barcode leftovers at the ends and/or in the middle of the long-reads with [Porechop_ABI](https://github.com/bonsai-team/Porechop_ABI) (an extension of [Porechop](https://github.com/rrwick/Porechop)).

Before you start you need your basecalled long-reads in one folder and make sure your sample names meet the following naming convention:
```
<Sample_name>.fastq.gz

# Example
Sample_1.fastq.gz
Sample_2.fastq.gz
...
```

#### Quality filter your reads with:
```
ngs4_np_qf -i ~/ngs4ecoprod/ngs4ecoprod/example_data/nanopore -o ~/ngs4_np -p 3 -t 12
```

#### Options for `ngs4_np_qf`
```
         -i     Input folder containing nanopore raw data as fastq.gz
                Note: files must be named according to the following scheme (ending with .fastq.gz)
                SampleName.fastq.gz
         -o     Output folder
         -q     Optional: Minimum phred score [default: 15]
                Note: you might have to lower these for old chemistry/flow cells (<R10.4)
         -l     Optional: Minimum length of nanopore read [default: 500]
         -p     Number of processes [default: 1]
         -t     Number of CPU threads per process [default: 1]
         -h     Print this help
```

#### 2. Taxonomic composition of long-reads (optional)

To get a "rough" estimate of the taxonomic composition of your metagenomes you can use `ngs4_np_tax` which is a combination of Kraken2 and Kaiju against NCBIs nt and nr, respectively. These tools need large databases and also some more RAM (up to 5XX Gb) per process. The script will produce a read count table which you can the analyse in R.

#### Assign taxonomy to your long-reads:
```
ngs4_np_tax -i ~/ngs4_np -d ~/860_EVO_4TB/NGS-4-ECOPROD/db/ -p 1 -t 20 -m
```

#### Options for `ngs4_np_tax`
```
         -i     Folder containing quality filtered fastq.gz
         -d     Path to databases (kraken2 & kaiju)
         -p     Number of processes [default: 1]
                NOTE: per process you need 183-470 Gb of RAM
         -t     Number of CPU threads per process [default: 1]
         -m     Reduce RAM requirements to 183 Gb (--memory-mapping for kraken2), slower
                NOTE: If your database is NOT located on a SSD expect long processing times
         -h     Print this help
```
#

#### 3. Assembly of long reads & generating metagenome assembled genomes

Now to the interesting part: assemble your quality filtered long-reads and generate metagenome assembled genomes (MAGs). This task is performed by [NanoPhase](https://github.com/Hydro3639/NanoPhase) which uses several tools to complete this task: metaWRAP, maxbin2, metabat2, semibin, checkm, GTDB-tk among others.

#### Assembly and binning of long-reads:
```
ngs4_np_assembly -i ~/ngs4_np -p 1 -t 20
```

#### Options for `ngs4_np_assembly`
```
         -i     Folder containing quality filtered fastq.gz
         -p     Number of processes [default: 1]
                NOTE: Better ony use one process here - depending on your system
         -t     Number of CPU threads per process [default: 1]
         -h     Print this help
```
#



### 3. Metagenomics with Illumina data

1. Quality filtering of paired-end sequences
This will perform quality filtering on your raw sequence data. In detail low quality sequences will be removed, sequences will be trimmed if quality drops below the threshold, if reads overlap sequences will be polished according to the consensus.

NOTE: There is one requirement for the script to work (see example files), your file names have to meet the following scheme: 
Sample1_R1.fastq.gz & Sample1_R2.fastq.gz
```
ngs4_qf -i ~/ngs4ecoprod/ngs4ecoprod/example_data -o ~/ngs4_test_run -d ~/ngs4ecoprod/ngs4ecoprod/db -p 3 -t 14
```

2. Taxonomic classification of quality filtered paired short-reads 
With script you assign taxonomy to your data with Kraken2 and Kaiju. Both classifications will be merged while Kraken2 annotation (more precision) is prioritized over Kaiju annotation (more sensitivity). In the end you will have an relative abundance table with taxonomic assignments.

NOTE: This step is RAM intensive, per process you need at least 183 (-m) or 450 Gb of RAM
      In addition, make sure you have both databases located on a SSD drive!
```
ngs4_tax -i ~/ngs4_test_run -d ~/860_EVO_4TB/NGS-4-ECOPROD/db -p 1 -t 10 -m
```

3. Assembly of of quality filtered short-reads
```
ngs4_assemble
```
#

# Author
Dominik Schneider (dschnei1@gwdg.de)
#

# Citation
Since this repository currently has no associated publication, please cite it via the GitHub link: https://github.com/dschnei1/ngs4ecoprod
Please also note that you have to cite all the sophisticated software tools that are incorporated within this pipeline: [software list](software.txt)