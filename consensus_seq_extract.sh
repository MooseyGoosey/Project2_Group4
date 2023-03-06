  GNU nano 2.3.1                                                                                            File: restart.sh

#!/bin/bash
#SBATCH --job-name=restart
#SBATCH --partition=hpc
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --mem=30g
#SBATCH --time=24:00:00
#SBATCH --output=/shared/Project2_Resources/Group4/OandE/%x.out
#SBATCH --error=/shared/Project2_Resources/Group4/OandE/%x.err

#activate freebayes conda
source $HOME/.bash_profile
conda activate /shared/Project2_Resources/Group4/shared_envs/freebayes
cd /shared/Project2_Resources/Group4/

#Set Variables
ref=./HPC/Reference_Genome/C_excelsa_V5.fasta
bam1=./HPC/bams/genes_for_students_Nent30_D10_purged_toExcelsa.bam
bam2=./HPC/bams/genes_for_students_Rot26_D10_purged_toExcelsa.bam
out=./restart/
out2=./restart/filtered_final_out/
vcfdip=./HPC/VCFs/For_Students_2023/filteredUK_scan_dips.vcf
vcftet=./HPC/VCFs/For_Students_2023/filteredUK_scan_tets.vcf

bgzip -c $vcfdip > "$vcfdip".gz
bgzip -c $vcftet > "$vcftet".gz

gvcfdip=./HPC/VCFs/For_Students_2023/filteredUK_scan_dips.vcf.gz
gvcftet=./HPC/VCFs/For_Students_2023/filteredUK_scan_tets.vcf.gz

tabix $gvcfdip
tabix $gvcftet

#Variant calling with freebayes
freebayes -f $ref -r Cexcelsa_scaf_1:4089822-4095817 -@ $gvcfdip -p 2 $bam1 >"$out"g10739_dips1.vcf
freebayes -f $ref -r Cexcelsa_scaf_6:3691706-3696294 -@ $gvcfdip -p 2 $bam1 >"$out"g50328_dips2.vcf
freebayes -f $ref -r Cexcelsa_scaf_2:28893505-28895015 -@ $gvcfdip -p 2 $bam1 >"$out"g44492_dips3.vcf
freebayes -f $ref -r Cexcelsa_scaf_1:4089822-4095817 -@ $gvcftet -p 4 $bam2 >"$out"g10739_tets4.vcf
freebayes -f $ref -r Cexcelsa_scaf_6:3691706-3696294 -@ $gvcftet -p 4 $bam2 >"$out"g50328_tets5.vcf
freebayes -f $ref -r Cexcelsa_scaf_2:28893505-28895015 -@ $gvcftet -p 4 $bam2 >"$out"g44492_tets6.vcf

#activate bcftools conda
conda deactivate
source $HOME/.bash_profile
conda activate /shared/Project2_Resources/Group4/shared_envs/sambcf


#Index VCFs
vcfs=./restart/*.vcf
for file in $vcfs;
do
     filename=$(basename "$file" .vcf)
     bgzip -c $file > "$out""$filename".vcf.gz
done
gzvcf=./restart/*.vcf.gz
for file in $gzvcf;
do
     tabix $file
done


#Generate consensus sequence for exon only regions and full sequence
for file in $gzvcf;
do
     filename=$(basename "$file" .vcf.gz)
     if [[ $file == "$out"g50328*.vcf.gz ]]; then
       samtools faidx $ref Cexcelsa_scaf_6:3695804-3696294 Cexcelsa_scaf_6:3695118-3695719 Cexcelsa_scaf_6:3694528-3695033 Cexcelsa_scaf_6:3694030-3694440 Cexcelsa_scaf_6:3692348-3693937 Cexcelsa_scaf_6:3691707-3692252 | bcftools consensus $file -o "$out2""$filename"_exon.fa
       samtools faidx $ref Cexcelsa_scaf_6:3691706-3696294 | bcftools consensus $file -o "$out2""$filename"_full.fa
     elif [[ $file == "$out"g10739*.vcf.gz ]]; then
       samtools faidx $ref Cexcelsa_scaf_1:4095613-4095817      Cexcelsa_scaf_1:4095447-4095497 Cexcelsa_scaf_1:4095256-4095347 Cexcelsa_scaf_1:4095047-4095124 Cexcelsa_scaf_1:4094816-4094973 Cexcelsa_scaf_1:4094638-4094739 Cexcelsa_scaf_1:4094431-4094548 Cexcelsa_scaf_1:4094297-4094349 Cexcelsa_scaf_1:4094155-40$
       samtools faidx $ref Cexcelsa_scaf_1:4089822-4095817 | bcftools consensus $file -o "$out2""$filename"_full.fa
     elif [[ $file == "$out"g44492*.vcf.gz ]]; then
       samtools faidx $ref Cexcelsa_scaf_2:28894742-28895015 Cexcelsa_scaf_2:28894013-28894486 Cexcelsa_scaf_2:28893505-28893797 | bcftools consensus $file -o "$out2""$filename"_exon.fa
       samtools faidx $ref Cexcelsa_scaf_2:28893505-28895015 | bcftools consensus $file -o "$out2""$filename"_full.fa

     fi
done


