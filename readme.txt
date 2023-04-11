All scripts used in Project 2 by Group 4.
Oliver Hargreaves - Coding
Rohith Varma-Penumetsha - Interpretation/Analysis
Thomas Murray – Presentation

All scripts were run as is on hpc through SLURM. No command line options.

gatk.sh
The initial VCF filtering step to include only NEN an ROT indiviuals from supplied diploid and tetraploid VCFs. Outputs two new VCFs with prefix “filtered(filename).vcf”

Freebayes_seq_extract.sh
The initial consensus sequence generation script. Produces new VCFs including variants from the filtered supplied VCF and bam files. Uses these new VCFs to generate
consensus sequences via a SAMtools/BCFtools pipe. Full and exon only sequences output as .fa files.

gatk_new.sh
A second VCF filtering step after initial consensus sequences were unsatisfactory. Same as above but also filters only variants with allele frequency greater than 0.5.
Outputs two new VCFs with prefix “filtered2(filename).vcf”

consensus_seq_2.sh
Creates consensus sequences using the “filtered2” VCFs from gatk_new.sh. Uses a SAMtools/BCFtools pipe as before. Full and exon only sequences output as .fa files.


