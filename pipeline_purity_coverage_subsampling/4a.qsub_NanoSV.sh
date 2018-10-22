#! /bin/bash

. /hpc/cog_bioinf/kloosterman/users/jvalleinclan/bin/NanoSV/bin/activate

source SETTINGS

T_NAME=$TUMOR_NAME

for PCT in ${PURITIES[*]}
do
	cd tumor${PCT}

	for COUNT in ${PURITY_SAMPLES}
	do
		cd $COUNT

		for COVERAGE in ${COVERAGES[*]}
		do
			cd ${COVERAGE}x_coverage
		
			if [ ! -d vcfs ];then
                		mkdir vcfs
	        	fi

	        	for COV_COUNT in ${COVERAGES_SAMPLES}
        		do
				IF=./bams/${COUNT}.${COV_COUNT}.${T_NAME}_tumor${PCT}_${COVERAGE}x.bam
				OF=./vcfs/${COUNT}.${COV_COUNT}.${T_NAME}_tumor${PCT}_${COVERAGE}x.vcf
				CONFIG=$NANOSV_CONFIG
				BED=$TRUTH_BED

				echo "/hpc/cog_bioinf/kloosterman/users/jvalleinclan/bin/NanoSV/bin/NanoSV -c $CONFIG -b $BED -o $OF $IF"\
| qsub -N "NanoSV_$(basename $IF)" -cwd -m beas -M S.deBlank@umcutrecht.nl -l h_rt=1:0:0 -l h_vmem=30G -o ${LOGS_FOLDER}/NanoSV_$(basename $IF).out -e ${LOGS_FOLDER}/NanoSV_$(basename $IF).err
			done

			cd ..
		done
		cd ..
	done
	cd ..
done
