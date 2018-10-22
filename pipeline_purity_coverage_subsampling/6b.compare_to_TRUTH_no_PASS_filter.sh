#! /bin/bash
#$ -cwd
#$ -m beas
#$ -M S.deBlank@umcutrecht.nl
#$ -l h_rt=1:0:0
#$ -l h_vmem=20G
#$ -N 'Overlap_bnd50_Allcoverages'

source SETTINGS

T_NAME=$TUMOR_NAME


for PCT in ${PURITIES[*]}
do
	cd tumor${PCT}

	for COUNT in ${PURITY_SAMPLES[*]}
	do
		cd $COUNT
		
		dir=${OVERLAP_DISTANCE}bp_overlap_noPASSfiltering_truth_allCoverages
        	if [ ! -d $dir ];then
               		mkdir ./${dir}
        	fi
		
		for COV_COUNT in ${COVERAGES_SAMPLES[*]}
		do	
			
			if [ ! -d ./${dir}/${COUNT}.${COV_COUNT} ];then
                        	mkdir ./${dir}/${COUNT}.${COV_COUNT}
                        fi
			
			OF=./${dir}/${COUNT}.${COV_COUNT}/${COUNT}.${COV_COUNT}.${T_NAME}_tumor${PCT}_overlapTRUTH.vcf
			IF=$TRUTH_VCF

			for COVERAGE in ${COVERAGES[*]}
			do
	
				OF=${OF/.vcf/_${COVERAGE}.vcf}		
				CF=./${COVERAGE}x_coverage/vcfs/${COUNT}.${COV_COUNT}.${T_NAME}_tumor${PCT}_${COVERAGE}x.vcf

				python /hpc/cog_bioinf/kloosterman/users/sdeblank/scripts/python/annotate_sv_vcf_file_without_ori_changeline268.py --input $IF --file2 $CF --distance ${OVERLAP_DISTANCE} --annotation "${COVERAGE}x_coverage"  > ${OF}
				IF=$OF
				
			done


		done

		cd ..

	done
	
	cd ..
done





