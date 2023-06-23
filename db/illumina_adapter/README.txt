The adapter sequences were retrived from https://github.com/s-andrews/FastQC/blob/master/Configuration/contaminant_list.txt
Afterwards, spaces were replaced with underscores and sequences were dereplecated with vsearch (--derep_fulllength).
Subsequently, for easy use with cutadapt sequences were converted to reverse and reverse complement with https://www.genscript.com/sms2/rev_comp.html
Finally, correct fasta format:
awk '/^>/ {printf("\n%s\n",$0);next; } { printf("%s",$0);}  END {printf("\n");}' < ../ASV_sequences.fasta | tail -n +2 > temp && mv temp ../ASV_sequences.fasta -f
awk '/^>/ {printf("\n%s\n",$0);next; } { printf("%s",$0);}  END {printf("\n");}' < fastqc_adapter_reverse_complement.fasta | tail -n +2 > temp && mv temp fastqc_adapter_reverse_complement.fasta -f
