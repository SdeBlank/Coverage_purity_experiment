#! /bin/bash

source SETTINGS

INPUT=${TUMOR_BAM/_65bnd/}
BED=${TRUTH_BED}
OUTPUT=$TUMOR_BAM


############### ADD SPLITTING OF NORMAL FILE ###################


if [ ! -a ./logs ]; then
	mkdir ./logs
fi 

echo "/hpc/local/CentOS7/cog_bioinf/sambamba_v0.6.5/sambamba view -h -f bam -L $BED -o $OUTPUT $INPUT"\
|qsub -N "$(basename $INPUT)_BND_filtering" -cwd -m beas -M S.deBlank@umcutrecht.nl -l h_rt=2:0:0 -l h_vmem=30G -o ./logs/$(basename $INPUT)_BND_filtering.err -e ./logs/$(basename $INPUT)_BND_filtering.out


