#! /bin/bash

. /hpc/cog_bioinf/kloosterman/users/jvalleinclan/bin/NanoSV/bin/activate

source SETTINGS

for F in ${PURITIES[*]}
do
	cd tumor${F}

	for COUNT in ${PURITY_SAMPLES[*]}
	do
		cd $COUNT

		for COVERAGE in ${COVERAGES[*]}
		do
			cd ${COVERAGE}x_coverage
		
			if [ ! -d vcfs ];then
                		mkdir vcfs
	        	fi

	        	for COV_COUNT in ${COVERAGES_SAMPLES[*]}
        		do
				IF=./bams/${COV_COUNT}.nanopore_colo829_tumor${F}_${COVERAGE}x.bam
				OF=./vcfs/${COV_COUNT}.nanopore_colo829_tumor${F}_${COVERAGE}x.vcf
				CONFIG=../../../config.ini
				BED=/hpc/cog_bioinf/kloosterman/users/jvalleinclan/bin/NanoSV/bin/human_hg19.bed

				echo "/hpc/cog_bioinf/kloosterman/users/jvalleinclan/bin/NanoSV/bin/NanoSV -c $CONFIG -b $BED -o $OF $IF"\
| qsub -N "NanoSV_$(basename $IF)" -cwd -m beas -M S.deBlank@umcutrecht.nl -l h_rt=1:0:0 -l h_vmem=30G
			done

			cd ..
		done
		cd ..
	done
	cd ..
done
