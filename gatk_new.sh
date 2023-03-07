  GNU nano 2.3.1                                                                              File: gatk2.sh

#!/bin/bash
#SBATCH --job-name=g4gatk
#SBATCH --partition=hpc
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --mem=30g
#SBATCH --time=24:00:00
#SBATCH --output=/shared/Project2_Resources/Group4/OandE/%x.out
#SBATCH --error=/shared/Project2_Resources/Group4/OandE/%x.err

# These steps are required to activate Conda
source $HOME/.bash_profile
conda activate /shared/Project2_Resources/Group4/shared_envs/gatk

#change directory
cd /shared/Project2_Resources/Group4/

#set variables
input1=./HPC/VCFs/For_Students_2023/UK_scan_dips.vcf
input2=./HPC/VCFs/For_Students_2023/UK_scan_tets.vcf
out=./HPC/VCFs/For_Students_2023/
echo "input file: $input"

#filter out desired individuals with gatk
filename=$(basename "$input1" .vcf)
gatk SelectVariants --restrict-alleles-to BIALLELIC -V $input1 --select "AF > 0.5" -sn NEN_001 -sn NEN_003 -sn NEN_200 -sn NEN_300 -sn NEN_4 -sn NEN_5 -sn NEN_6 -O "$out"filtered2"$filename".vcf
filename=$(basename "$input2" .vcf)
gatk SelectVariants --restrict-alleles-to BIALLELIC -V $input2 --select "AF > 0.5" -sn ROT_004 -sn ROT_006 -sn ROT_007 -sn ROT_013 -O "$out"filtered2"$filename".vcf

#set new variables
input3=./HPC/VCFs/For_Students_2023/filtered*.vcf

#Select regions of our 3 genes and filter out only variants within them using gatk
for file in $input3;
do
     filename=$(basename "$file" .vcf)
     gatk SelectVariants -V $file -L Cexcelsa_scaf_6:3691706-3696294 -O "$out"g50328"$filename".vcf
     gatk SelectVariants -V $file -L Cexcelsa_scaf_1:4089822-4095817 -O "$out"g10739"$filename".vcf
     gatk SelectVariants -V $file -L Cexcelsa_scaf_2:28893505-28895015 -O "$out"g44492"$filename".vcf
done

