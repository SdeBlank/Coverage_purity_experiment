#! /bin/bash


source SETTINGS

NORMAL=${NORMAL_BAM}
TUMOR=${TUMOR_BAM}

nr=10
count=0

for PCT in ${PURITIES[*]}
do	

	echo "Busy"

	F=$(awk -v PCT="$PCT" 'BEGIN{print PCT/100}')	

	FN=$(awk -v F="$F" 'BEGIN{print 1-F}')

	if [ ! -a ./tumor${PCT}/ ]; then
        	mkdir ./tumor${PCT}
        fi

	cd ./tumor${PCT}	


	for COUNT in ${PURITY_SAMPLES[*]}
	do
		
	        if [ ! -d ./${COUNT} ];then
        	        mkdir ./${COUNT}
	        fi
	
		cd ./${COUNT}		

		if [ ! -d ./bams ];then
                        mkdir ./bams
                fi
		
		cd ./bams

		echo "/hpc/local/CentOS7/cog_bioinf/sambamba_v0.6.5/sambamba view -f bam -s $F -o ./colo829_tumor_subsample_${F}.bam $TUMOR" | qsub -cwd -m beas -M S.deblank@umcutrecht.nl -l h_rt=1:0:0 -l h_vmem=30G -N tumor${pct}_${count}_split
		echo "/hpc/local/CentOS7/cog_bioinf/sambamba_v0.6.5/sambamba view -f bam -s $FN -o ./colo829_normal_subsample_${FN}.bam $NORMAL" | qsub -cwd -m beas -M S.deBlank@umcutrecht.nl -l h_rt=1:0:0 -l h_vmem=30G -N tumor${pct}_${count}_split
		echo "/hpc/local/CentOS7/cog_bioinf/sambamba_v0.6.5/sambamba merge nanopore_colo829_tumor${PCT}.bam ./colo829_tumor_subsample_${F}.bam ./colo829_normal_subsample_${FN}.bam" | qsub -hold_jid tumor${pct}_${count}_split -cwd -m beas -M S.deBlank@umcutrecht.nl -l h_rt=1:0:0 -l h_vmem=30G -N tumor${pct}_${count}_merge
		
		cd ../../
	done	
	cd ..
done
