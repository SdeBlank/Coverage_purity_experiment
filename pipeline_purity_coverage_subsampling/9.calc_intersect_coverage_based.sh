#! /bin/bash

source SETTINGS


if [ ! -d coverage_recall ];then
	mkdir recall_coverage_based
fi

cd recall_coverage_based

if [ ! -d per_sample ];then
        mkdir per_sample
fi

cd per_sample

for COVERAGE in ${COVERAGES[*]}
do
	for COV_COUNT in ${COVERAGES_SAMPLES[*]}
	do
		echo "Sample" > nrtumorsamples.txt
		

		for COUNT in ${PURITY_SAMPLES[*]}
		do
			echo "${COV_COUNT}.${COUNT}" >>  nrtumorsamples.txt
		done

		for F in ${PURITIES[*]}
		do
			if [ -f ${COV_COUNT}.tumor${F}_recall50BND.txt ];then
                                rm ${COV_COUNT}.tumor${F}_recall50BND.txt
                        fi
			
			echo "tumor${F}" >> ${COV_COUNT}.tumor${F}_recall50BND.txt

			for COUNT in ${PURITY_SAMPLES[*]}
			do
				
				tot=$(cut -f 7 ../../tumor${F}/$COUNT/100bp_overlap_bnd50_allCoverages/${COV_COUNT}/${COV_COUNT}.colo829_50bnd_40_*_3.vcf | grep -w -c "${COVERAGE}x_coverage")
				tot=`python -c "print str(int(${tot}-1))"`
				echo "${tot}" >> ${COV_COUNT}.tumor${F}_recall50BND.txt				

			done
		done
		
		rm ${COV_COUNT}.${COVERAGE}x_coverage_recall.txt
                touch ${COV_COUNT}.${COVERAGE}x_coverage_recall.txt

                for F in ${PURITIES[*]}
                do
                        paste ${COV_COUNT}.${COVERAGE}x_coverage_recall.txt ${COV_COUNT}.tumor${F}_recall50BND.txt > ${COV_COUNT}.${COVERAGE}x_coverage_recall.txt
                done

                paste nrtumorsamples.txt ${COV_COUNT}.${COVERAGE}x_coverage_recall.txt > ${COV_COUNT}.${COVERAGE}x_coverage_recall.txt

	done

	head -n 1 ./1.${COVERAGE}x_coverage_recall.txt > ../${COVERAGE}_all_purity_recall.txt

        for COV_COUNT in ${COVERAGES_SAMPLES[*]}
        do
                tail -n +2 ./${COV_COUNT}.${COVERAGE}x_coverage_recall.txt >> ../${COVERAGE}_all_purity_recall.txt
        done

done

