#! /bin/bash

module load R/3.4.1



for COVERAGE in 40 35 30 25 20 15 10 5 3
do
	cd recall_coverage_based
	Rscript ../nanosv_subsampling_boxplot.R ${COVERAGE}_all_purity_recall.txt ../plots/${COVERAGE}x_purity_recall.pdf
	cd ..
done
