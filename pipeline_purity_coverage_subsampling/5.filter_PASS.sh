#! /bin/bash
#$ -cwd
#$ -m beas
#$ -M S.deBlank@umcutrecht.nl
#$ -l h_rt=1:0:0
#$ -l h_vmem=20G
#$ -N 'Overlap_bnd50_Allcoverages'

module load python/3.6.1

source SETTINGS

T_NAME=$TUMOR_NAME


for PCT in ${PURITIES[*]}
do
        cd tumor${PCT}

        for COUNT in ${PURITY_SAMPLES[*]}
        do
                cd $COUNT
		
		for COVERAGE in ${COVERAGES[*]}
                do
                        cd ${COVERAGE}x_coverage/vcfs
			
			for COV_COUNT in ${COVERAGES_SAMPLES[*]}
                        do

				TUMOR=./${COUNT}.${COV_COUNT}.${T_NAME}_tumor${PCT}_${COVERAGE}x.vcf
				
				python /hpc/cog_bioinf/kloosterman/users/sdeblank/scripts/python/vcf_filter_on_FILTER.py $TUMOR "PASS"
			done

			cd ../../
		done
		
		cd ..
	done

	cd ..
done
