  GNU nano 2.3.1                                                                                                                                                                                                                                                                                                             File: VCFrestart.sh

#!/bin/bash
#SBATCH --job-name=vcfrestart
#SBATCH --partition=hpc
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --mem=30g
#SBATCH --time=24:00:00
#SBATCH --output=/shared/Project2_Resources/Group4/OandE/%x.out
#SBATCH --error=/shared/Project2_Resources/Group4/OandE/%x.err

#activate bcftools conda
source $HOME/.bash_profile
conda activate /shared/Project2_Resources/Group4/shared_envs/sambcf
cd /shared/Project2_Resources/Group4/

#Set Variables
ref=./HPC/Reference_Genome/C_excelsa_V5.fasta
bam1=./HPC/bams/genes_for_students_Nent30_D10_purged_toExcelsa.bam
bam2=./HPC/bams/genes_for_students_Rot26_D10_purged_toExcelsa.bam
out=./HPC/VCFs/For_Students_2023/
out2=./restart/filtered_final_out/VCF_only/
vcfdip=./HPC/VCFs/For_Students_2023/filtered2UK_scan_dips.vcf
vcftet=./HPC/VCFs/For_Students_2023/filtered2UK_scan_tets.vcf

bgzip $vcfdip
bgzip $vcftet

gvcfdip=./HPC/VCFs/For_Students_2023/filtered2UK_scan_dips.vcf.gz
gvcftet=./HPC/VCFs/For_Students_2023/filtered2UK_scan_tets.vcf.gz
echo "$gvcfdip"
echo "$gvcftet"

tabix $gvcfdip
tabix $gvcftet

#Generate consensus sequence for exon only regions and full sequence
for file in $gvcfdip;
do
       samtools faidx $ref Cexcelsa_scaf_6:3695804-3696294 Cexcelsa_scaf_6:3695118-3695719 Cexcelsa_scaf_6:3694528-3695033 Cexcelsa_scaf_6:3694030-3694440 Cexcelsa_scaf_6:3692348-3693937 Cexcelsa_scaf_6:3691707-3692252 | bcftools consensus $file -o "$out2"g50328_dips_VCF_exon.fa
       samtools faidx $ref Cexcelsa_scaf_6:3691706-3696294 | bcftools consensus $file -o "$out2"g50328_dips_VCF_full.fa
       samtools faidx $ref Cexcelsa_scaf_1:4095613-4095817      Cexcelsa_scaf_1:4095447-4095497 Cexcelsa_scaf_1:4095256-4095347 Cexcelsa_scaf_1:4095047-4095124 Cexcelsa_scaf_1:4094816-4094973 Cexcelsa_scaf_1:4094638-4094739 Cexcelsa_scaf_1:4094431-4094548 Cexcelsa_scaf_1:4094297-4094349 Cexcelsa_scaf_1:4094155-4094220 Cexcelsa_scaf_1:4094021-4094065 Cexcelsa_scaf_1:4093853-4093905 Cexcelsa_scaf_1:4093223-4093407 Cexcelsa_scaf_1:4093097-4093141 Cexcelsa_scaf_1:4092891-4092998 Cexcelsa_scaf_1:4092430-4092658 Cexcelsa_scaf_1:4092042-4092344 Cexcelsa_scaf_1:4091820-4091917 Cexcelsa_scaf_1:4091605-4091736 Cexcelsa_scaf_1:4091302-4091520 Cexcelsa_scaf_1:4091001-4091207 Cexcelsa_scaf_1:4090646-4090916 Cexcelsa_scaf_1:4090244-4090554 Cexcelsa_scaf_1:4089823-4090137 | bcftools consensus $file -o "$out2"g10739_dips_VCF_exon.fa
       samtools faidx $ref Cexcelsa_scaf_1:4089822-4095817 | bcftools consensus $file -o "$out2"g10739_dips_VCF_full.fa
       samtools faidx $ref Cexcelsa_scaf_2:28894742-28895015 Cexcelsa_scaf_2:28894013-28894486 Cexcelsa_scaf_2:28893505-28893797 | bcftools consensus $file -o "$out2"g44492_dips_VCF_exon.fa
       samtools faidx $ref Cexcelsa_scaf_2:28893505-28895015 | bcftools consensus $file -o "$out2"g44492_dips_VCF_full.fa
done
for file in $gvcftet;
do
       samtools faidx $ref Cexcelsa_scaf_6:3695804-3696294 Cexcelsa_scaf_6:3695118-3695719 Cexcelsa_scaf_6:3694528-3695033 Cexcelsa_scaf_6:3694030-3694440 Cexcelsa_scaf_6:3692348-3693937 Cexcelsa_scaf_6:3691707-3692252 | bcftools consensus $file -o "$out2"g50328_tets_VCF_exon.fa
       samtools faidx $ref Cexcelsa_scaf_6:3691706-3696294 | bcftools consensus $file -o "$out2"g50328_tets_VCF_full.fa
       samtools faidx $ref Cexcelsa_scaf_1:4095613-4095817      Cexcelsa_scaf_1:4095447-4095497 Cexcelsa_scaf_1:4095256-4095347 Cexcelsa_scaf_1:4095047-4095124 Cexcelsa_scaf_1:4094816-4094973 Cexcelsa_scaf_1:4094638-4094739 Cexcelsa_scaf_1:4094431-4094548 Cexcelsa_scaf_1:4094297-4094349 Cexcelsa_scaf_1:4094155-4094220 Cexcelsa_scaf_1:4094021-4094065 Cexcelsa_scaf_1:4093853-4093905 Cexcelsa_scaf_1:4093223-4093407 Cexcelsa_scaf_1:4093097-4093141 Cexcelsa_scaf_1:4092891-4092998 Cexcelsa_scaf_1:4092430-4092658 Cexcelsa_scaf_1:4092042-4092344 Cexcelsa_scaf_1:4091820-4091917 Cexcelsa_scaf_1:4091605-4091736 Cexcelsa_scaf_1:4091302-4091520 Cexcelsa_scaf_1:4091001-4091207 Cexcelsa_scaf_1:4090646-4090916 Cexcelsa_scaf_1:4090244-4090554 Cexcelsa_scaf_1:4089823-4090137 | bcftools consensus $file -o "$out2"g10739_tets_VCF_exon.fa
       samtools faidx $ref Cexcelsa_scaf_1:4089822-4095817 | bcftools consensus $file -o "$out2"g10739_tets_VCF_full.fa
       samtools faidx $ref Cexcelsa_scaf_2:28894742-28895015 Cexcelsa_scaf_2:28894013-28894486 Cexcelsa_scaf_2:28893505-28893797 | bcftools consensus $file -o "$out2"g44492_tets_VCF_exon.fa
       samtools faidx $ref Cexcelsa_scaf_2:28893505-28895015 | bcftools consensus $file -o "$out2"g44492_tets_VCF_full.fa
done



