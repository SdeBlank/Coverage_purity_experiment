#! /bin/bash

source SETTINGS

T_NAME=$TUMOR_NAME


if [ ! -a ./truth_recall ];then
	mkdir truth_recall
fi

OVERLAP=${OVERLAP_DISTANCE}bp_overlap_noPASSfiltering

if [ ! -a ./truth_recall/${OVERLAP} ];then
        mkdir ./truth_recall/${OVERLAP}
fi


for PCT in ${PURITIES[*]}
do
        cd tumor${PCT}

        for COUNT in ${PURITY_SAMPLES[*]}
        do
                cd $COUNT
		cd ${OVERLAP}_truth_allCoverages

		echo "Purity" > purity.txt
		echo "Sample" > nrtumorsamples.txt
		echo "0x" > 0x_recall50BND.txt

                for COV_COUNT in ${COVERAGES_SAMPLES[*]}
                do
			echo "${COUNT///}.${COV_COUNT}" >> nrtumorsamples.txt
			echo "${PCT}" >> purity.txt
			echo "0" >> 0x_recall50BND.txt
		done
                
		for COVERAGE in ${COVERAGES[*]}
		do
			if [ -f ${COVERAGE}x_recallTRUTH.txt ];then
				rm ${COVERAGE}x_recallTRUTH.txt
			fi

                        echo "${COVERAGE}x" >> ${COVERAGE}x_recallTRUTH.txt

			for COV_COUNT in ${COVERAGES_SAMPLES[*]}
                        do
				tot=$(cut -f 7 ./${COUNT}.${COV_COUNT}/${COUNT}.${COV_COUNT}.${T_NAME}_tumor${PCT}_overlapTRUTH_${COVERAGES[0]}*${COVERAGES[-1]}.vcf | grep -w -c "${COVERAGE}x_coverage")
                		tot=`python -c "print (str(int(${tot}-1)))"`
                		echo "${tot}" >> ${COVERAGE}x_recallTRUTH.txt								
                        done
                done
		
		paste purity.txt nrtumorsamples.txt > AllCoveragesRecall.txt

		for COVERAGE in ${COVERAGES[*]}
		do
			paste AllCoveragesRecall.txt ${COVERAGE}x_recallTRUTH.txt > AllCoveragesRecall2.txt && mv AllCoveragesRecall2.txt AllCoveragesRecall.txt
		done
		
                cd ../../

        done
	
		
	head -n 1 ./1/${OVERLAP}_truth_allCoverages/AllCoveragesRecall.txt > ../truth_recall/${OVERLAP}/tumor${PCT}_AllCoveragesRecall.txt
	
	for COUNT in ${PURITY_SAMPLES[*]}
	do
		tail -n +2 ./${COUNT}/${OVERLAP}_truth_allCoverages/AllCoveragesRecall.txt >> ../truth_recall/${OVERLAP}/tumor${PCT}_AllCoveragesRecall.txt
	done

        cd ..
done



head -n 1 ./truth_recall/${OVERLAP}/tumor100_AllCoveragesRecall.txt > ./truth_recall/${OVERLAP}/all_purities_all_coverages_recall.txt

for file in ./truth_recall/${OVERLAP}/tumor*_AllCoveragesRecall.txt
do
	tail -n +2 $file >> ./truth_recall/${OVERLAP}/all_purities_all_coverages_recall.txt
done

