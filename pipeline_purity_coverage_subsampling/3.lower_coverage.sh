#! /bin/bash

source SETTINGS

for PCT in ${PURITIES[*]}
do
	cd tumor${PCT}

	for COUNT in ${PURITY_SAMPLES}
	do
		echo $COUNT
		cd $COUNT		

		BED=$TRUTH_BED

		TUMOR=$(pwd)/bams/${COUNT}.${TUMOR_NAME}_tumor${PCT}.bam

		read_depth_TUMOR=$(/hpc/cog_bioinf/kloosterman/users/sdeblank/scripts/bash/read_depth.sh $TUMOR $BED)

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
		
			for COV_COUNT in ${COVERAGES_SAMPLES}
			do
				TUMOR_OUTPUT=$(basename $TUMOR)
				TUMOR_OUTPUT=${TUMOR_OUTPUT/${COUNT}./${COUNT}.${COV_COUNT}.}
                        	TUMOR_OUTPUT=${TUMOR_OUTPUT/.bam/_${COVERAGE}x.bam}

				echo $TUMOR_OUTPUT


				echo "/hpc/local/CentOS7/cog_bioinf/sambamba_v0.6.5/sambamba view -f bam -s $SUBSAMPLE_TUMOR -o $TUMOR_OUTPUT $TUMOR"\
| qsub -N N$(basename $TUMOR)_to_${COVERAGE}x_coverage -cwd -m beas -M S.deBlank@umcutrecht.nl -l h_rt=1:0:0 -l h_vmem=30G -o ${LOGS_FOLDER}/$(basename $TUMOR)_to_${COVERAGE}x_coverage.out -e ${LOGS_FOLDER}/$(basename $TUMOR)_to_${COVERAGE}x_coverage.err
			
			done			

			cd ../../
		done
		
		cd ..
	done
	cd ..
		
done
