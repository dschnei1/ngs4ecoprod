This data was downloaded from NCBI: https://trace.ncbi.nlm.nih.gov/Traces/?view=run_browser&acc=SRR17913199&display=metadata


prefetch SRR17913199
cd SRR17913199
fasterq-dump SRR17913199.sra
rm SRR17913199.sra -f
pigz -9 -p 42 SRR17913199.fastq
mv SRR17913199.fastq.gz ../
cd ..
rmdir SRR17913199