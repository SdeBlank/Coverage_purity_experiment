#! /bin/bash
#$ -cwd
#$ -m beas
#$ -M S.deBlank@umcutrecht.nl
#$ -l h_rt=1:0:0
#$ -l h_vmem=20G
#$ -N 'Overlap_bnd50_Allcoverages'

source SETTINGS

for F in ${PURITIES[*]}
do
	cd tumor${F}

	for COUNT in ${PURITY_SAMPLES[*]}
	do
		cd $COUNT
		
		dir=${OVERLAP_DISTANCE}bp_overlap_bnd50_allCoverages
        	if [ ! -d $dir ];then
               		mkdir ./${dir}
        	fi
		
		for COV_COUNT in ${COVERAGES_SAMPLES[*]}
		do	
			
			if [ ! -d ./${dir}/$COV_COUNT ];then
                        	mkdir ./${dir}/${COV_COUNT}
                        fi
			
			OF=./${dir}/${COV_COUNT}/${COV_COUNT}.colo829_50bnd.vcf
			IF=../../colo829.commonNSV_BPI_50bnd_NSVbased.vcf

			for COVERAGE in ${COVERAGES[*]}
			do
	
				OF=${OF/.vcf/_${COVERAGE}.vcf}		
				CF=./${COVERAGE}x_coverage/vcfs/${COV_COUNT}.nanopore_colo829_tumor${F}_${COVERAGE}x_PASS.vcf

				/hpc/cog_bioinf/kloosterman/users/sdeblank/Python_scripts/annotate_sv_vcf_file_without_ori.py --input $IF --file2 $CF --distance ${OVERLAP_DISTANCE} --annotation "${COVERAGE}x_coverage"  > ${OF}
				IF=$OF
				
			done


		done

		cd ..

	done
	
	cd ..
done





