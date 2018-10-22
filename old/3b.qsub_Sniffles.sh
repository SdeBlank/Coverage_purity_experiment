#! /bin/bash

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

				echo "/hpc/cog_bioinf/kloosterman/tools/Sniffles-master/bin/sniffles-core-1.0.8/sniffles -m $IF -v $OF -s 2 --max_num_splits 10 -d 10 -t 8 --report_BND --genotype"\
| qsub -N "Sniffles_$(basename $IF)" -cwd -m beas -M S.deBlank@umcutrecht.nl -l h_rt=1:0:0 -l h_vmem=30G
			done

			cd ..
		done
		cd ..
	done
	cd ..
done
