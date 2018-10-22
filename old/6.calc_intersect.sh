#! /bin/bash

source SETTINGS


if [ ! -d coverage_recall ];then
	mkdir recall
fi


for F in ${PURITIES[*]}
do
        cd tumor${F}

        for COUNT in ${PURITY_SAMPLES[*]}
        do
                cd $COUNT
		cd 100bp_overlap_bnd50_allCoverages

		echo "Purity" > purity.txt
		echo "Sample" > nrtumorsamples.txt
		echo "0x" > 0x_recall50BND.txt

                for COV_COUNT in ${COVERAGES_SAMPLES[*]}
                do
			echo "${COUNT///}.${COV_COUNT}" >> nrtumorsamples.txt
			echo "${F}" >> purity.txt
			echo "0" >> 0x_recall50BND.txt
		done
                
		for COVERAGE in ${COVERAGES[*]}
		do
			if [ -f ${COVERAGE}x_recall50BND.txt ];then
				rm ${COVERAGE}x_recall50BND.txt
			fi

                        echo "${COVERAGE}x" >> ${COVERAGE}x_recall50BND.txt

			for COV_COUNT in ${COVERAGES_SAMPLES[*]}
                        do
				tot=$(cut -f 7 ./${COV_COUNT}/${COV_COUNT}.colo829_50bnd_${COVERAGES[0]}_*_${COVERAGES[-1]}.vcf | grep -w -c "${COVERAGE}x_coverage")      #CHANGE 40_*_3 to coverage range used
                		tot=`python -c "print (str(int(${tot}-1)))"`
                		echo "${tot}" >> ${COVERAGE}x_recall50BND.txt								
                        done
                done
		
		paste purity.txt nrtumorsamples.txt > AllCoveragesRecall.txt

		for COVERAGE in ${COVERAGES[*]}
		do
			paste AllCoveragesRecall.txt ${COVERAGE}x_recall50BND.txt > AllCoveragesRecall2.txt && mv AllCoveragesRecall2.txt AllCoveragesRecall.txt
		done
		
                cd ../../

        done
	
		
	head -n 1 ./1/100bp_overlap_bnd50_allCoverages/AllCoveragesRecall.txt > ../recall/tumor${F}_AllCoveragesRecall.txt
	
	for COUNT in ${PURITY_SAMPLES[*]}
	do
		tail -n +2 ./${COUNT}/100bp_overlap_bnd50_allCoverages/AllCoveragesRecall.txt >> ../recall/tumor${F}_AllCoveragesRecall.txt
	done

        cd ..
done



head -n 1 ./recall/tumor100_AllCoveragesRecall.txt > ./recall/all_purities_all_coverages_recall.txt

for file in ./recall/tumor*_AllCoveragesRecall.txt
do
	tail -n +2 $file >> ./recall/all_purities_all_coverages_recall.txt
done

