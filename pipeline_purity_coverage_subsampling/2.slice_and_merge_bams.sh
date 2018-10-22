#! /bin/bash

# Creating different tumour purities in silico

source SETTINGS

BED=${TRUTH_BED}

NORMAL=${NORMAL_BAM}
TUMOR=${TUMOR_BAM}

N_NAME=$NORMAL_NAME
T_NAME=$TUMOR_NAME

N_DEPTH=$(/hpc/cog_bioinf/kloosterman/users/sdeblank/scripts/bash/read_depth.sh $NORMAL $BED)
T_DEPTH=$(/hpc/cog_bioinf/kloosterman/users/sdeblank/scripts/bash/read_depth.sh $TUMOR $BED)

echo "Normal coverage: $N_DEPTH"
echo "Tumour coverage: $T_DEPTH"

DEPTH_DIFFERENCE=$(awk -v N_DEPTH="$N_DEPTH" -v T_DEPTH="$T_DEPTH" 'BEGIN{print T_DEPTH/N_DEPTH}')

echo "Difference in coverage: $DEPTH_DIFFERENCE"

nr=10
count=0

for PCT in ${PURITIES[*]}
do	

	echo "Busy ${PCT}"

	T_RATIO=$(awk -v PCT="$PCT" -v DEPTH_DIFFERENCE="$DEPTH_DIFFERENCE" 'BEGIN{print PCT/100/DEPTH_DIFFERENCE}')	

	N_RATIO=$(awk -v PCT="$PCT" -v T_RATIO="$T_RATIO" 'BEGIN{print 1-PCT/100}')
	
	echo "Tumour ratio: $T_RATIO"
	echo "Normal ratio: $N_RATIO"
	
	if [ ! -a ./tumor${PCT}/ ]; then
        	mkdir ./tumor${PCT}
        fi

	cd ./tumor${PCT}	

	
	for COUNT in ${PURITY_SAMPLES}
	do
		
	        if [ ! -d ./${COUNT} ];then
        	        mkdir ./${COUNT}
	        fi
	
		cd ./${COUNT}		

		if [ ! -d ./bams ];then
                        mkdir ./bams
                fi
		
		cd ./bams
		

		echo "/hpc/local/CentOS7/cog_bioinf/sambamba_v0.6.5/sambamba view -f bam -s $T_RATIO -o ./${COUNT}.${T_NAME}_subsample_tumor${PCT}.bam $TUMOR" | qsub -cwd -m beas -M S.deblank@umcutrecht.nl -l h_rt=1:0:0 -l h_vmem=30G -N tumor${PCT}_${COUNT}_split_tumor -o ${LOGS_FOLDER}/tumor${PCT}_${COUNT}_split_tumor.out -e ${LOGS_FOLDER}/tumor${PCT}_${COUNT}_split_tumor.err
		echo "/hpc/local/CentOS7/cog_bioinf/sambamba_v0.6.5/sambamba view -f bam -s $N_RATIO -o ./${COUNT}.${N_NAME}_subsample_tumor${PCT}.bam $NORMAL" | qsub -cwd -m beas -M S.deBlank@umcutrecht.nl -l h_rt=1:0:0 -l h_vmem=30G -N tumor${PCT}_${COUNT}_split_normal -o ${LOGS_FOLDER}/tumor${PCT}_${COUNT}_split_normal.out -e ${LOGS_FOLDER}/tumor${PCT}_${COUNT}_split_normal.err
		echo "/hpc/local/CentOS7/cog_bioinf/sambamba_v0.6.5/sambamba merge ${COUNT}.${T_NAME}_tumor${PCT}.bam ./${COUNT}.${T_NAME}_subsample_tumor${PCT}.bam ./${COUNT}.${N_NAME}_subsample_tumor${PCT}.bam" | qsub -hold_jid tumor${PCT}_${COUNT}_split_* -cwd -m beas -M S.deBlank@umcutrecht.nl -l h_rt=1:0:0 -l h_vmem=30G -N tumor${PCT}_${COUNT}_merge -o ${LOGS_FOLDER}/tumor${PCT}_${COUNT}_merge.out -e ${LOGS_FOLDER}/tumor${PCT}_${COUNT}_merge.err
		
		cd ../../
	done	
	cd ..
done
