These example metagenomes (sequenced with Illumina HiSeq 2500) were retrieved from NCBI:
1611Go_Inlet_R1.fastq.gz, 1611Go_Inlet_R2.fastq.gz PRJNA524094 SRX5445794
1611Go_SlAct_R1.fastq.gz, 1611Go_SlAct_R2.fastq.gz PRJNA524094 SRX5445798
1611Go_SlDig_R1.fastq.gz, 1611Go_SlDig_R2.fastq.gz PRJNA524094 SRX5445797
1611Go_UH_R1.fastq.gz, 1611Go_UH_R2.fastq.gz PRJNA524094 SRX5445800

Afterwards the files were subsetted to 150,000 reads with seqtk:
seqtk sample -s 123 1611Go_Inlet_R1.fastq.gz 150000 | pigz -9 -p 32 > 1611Go_Inlet_sub_R1.fastq.gz
seqtk sample -s 123 1611Go_Inlet_R2.fastq.gz 150000 | pigz -9 -p 32 > 1611Go_Inlet_sub_R2.fastq.gz
seqtk sample -s 123 1611Go_SlAct_R1.fastq.gz 150000 | pigz -9 -p 32 > 1611Go_SlAct_sub_R1.fastq.gz
seqtk sample -s 123 1611Go_SlAct_R2.fastq.gz 150000 | pigz -9 -p 32 > 1611Go_SlAct_sub_R2.fastq.gz
seqtk sample -s 123 1611Go_SlDig_R1.fastq.gz 150000 | pigz -9 -p 32 > 1611Go_SlDig_sub_R1.fastq.gz
seqtk sample -s 123 1611Go_SlDig_R2.fastq.gz 150000 | pigz -9 -p 32 > 1611Go_SlDig_sub_R2.fastq.gz
seqtk sample -s 123 1611Go_UH_R1.fastq.gz 150000 | pigz -9 -p 32 > 1611Go_UH_sub_R1.fastq.gz
seqtk sample -s 123 1611Go_UH_R2.fastq.gz 150000 | pigz -9 -p 32 > 1611Go_UH_sub_R2.fastq.gz
