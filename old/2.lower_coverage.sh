#! /bin/bash

source SETTINGS

for F in ${PURITIES[*]}
do
	cd tumor${F}

	for COUNT in ${PURITY_SAMPLES[*]}
	do
		echo $COUNT
		cd $COUNT		

		BED=/hpc/cog_bioinf/kloosterman/users/sdeblank/COLO829/tumor_subsampling/nanopore/coverage_purity_exp/colo829.commonNSV_BPI_50bnd_NSVbased.bed

		TUMOR=$(pwd)/bams/nanopore_colo829_tumor${F}.bam

		read_depth_TUMOR=$(/hpc/cog_bioinf/kloosterman/users/sdeblank/Tools/read_depth.sh $TUMOR $BED)

		echo $read_depth_TUMOR

		for COVERAGE in ${COVERAGES[*]}
		do

		        if [ ! -d ${COVERAGE}x_coverage ];then
		                mkdir ${COVERAGE}x_coverage
		        fi
	
			if [ ! -d ${COVERAGE}x_coverage/bams ];then
		                mkdir ${COVERAGE}x_coverage/bams
		        fi

			SUBSAMPLE_TUMOR=$(awk -v coverage="$COVERAGE" -v read_depth="$read_depth_TUMOR" 'BEGIN{print coverage/read_depth}')

			if (( $(awk -v subsample="$SUBSAMPLE_TUMOR" 'BEGIN {print (subsample>1)}') ));then
				SUBSAMPLE_TUMOR=1
			fi
	
			echo $SUBSAMPLE_TUMOR
	
			cd ${COVERAGE}x_coverage/bams
		
			for COV_COUNT in ${COVERAGES_SAMPLES[*]}
			do
				TUMOR_OUTPUT=${COV_COUNT}.$(basename $TUMOR)
                        	TUMOR_OUTPUT=${TUMOR_OUTPUT/.bam/_${COVERAGE}x.bam}


				echo "/hpc/local/CentOS7/cog_bioinf/sambamba_v0.6.5/sambamba view -f bam -s $SUBSAMPLE_TUMOR -o $TUMOR_OUTPUT $TUMOR"\
| qsub -N $(basename $TUMOR)_to_${COVERAGE}x_coverage -cwd -m beas -M S.deBlank@umcutrecht.nl -l h_rt=1:0:0 -l h_vmem=30G
			
			done			

			cd ../../
		done
		
		cd ..
	done
	cd ..
		
done
