#! /bin/bash
#$ -cwd
#$ -m beas
#$ -M S.deBlank@umcutrecht.nl
#$ -l h_rt=1:0:0
#$ -l h_vmem=20G
#$ -N 'Overlap_bnd50_Allcoverages'

module load python/3.6.1
source SETTINGS

for F in ${PURITIES[*]}
do
        cd tumor${F}

        for COUNT in ${PURITY_SAMPLES[*]}
        do
                cd $COUNT
		
		for COVERAGE in ${COVERAGES[*]}
                do
                        cd ${COVERAGE}x_coverage/vcfs
			
			for COV_COUNT in ${COVERAGES_SAMPLES[*]}
                        do
				python /hpc/cog_bioinf/kloosterman/users/sdeblank/Python_scripts/vcf_filter_on_FILTER.py ./${COV_COUNT}.nanopore_colo829_tumor${F}_${COVERAGE}x.vcf "PASS"
			done

			cd ../../
		done
		
		cd ..
	done

	cd ..
done
