#! /bin/bash

if [ ! -d plots ];then
	mkdir plots
fi

module load R/3.4.1

INPUT=./truth_recall/all_purities_all_coverages_recall.txt		### Table format of recall rate of all purities and coverages

#Rscript /hpc/cog_bioinf/kloosterman/users/sdeblank/R_scripts/boxplot_purity_vs_Xcoverage_vs_Yrecall.R $INPUT ./plots/purity_vs_Xcoverage_vs_Yrecall.pdf
#Rscript /hpc/cog_bioinf/kloosterman/users/sdeblank/R_scripts/boxplot_coverage_vs_Xpurity_vs_Yrecall.R $INPUT ./plots/coverage_vs_Xpurity_vs_Yrecall.pdf

Rscript /hpc/cog_bioinf/kloosterman/users/sdeblank/scripts/R/boxplot_purity_vs_Xcoverage_vs_Yrecall.R $INPUT ./plots/purity_vs_Xcoverage_vs_Yrecall.pdf
Rscript /hpc/cog_bioinf/kloosterman/users/sdeblank/scripts/R/boxplot_coverage_vs_Xpurity_vs_Yrecall.R $INPUT ./plots/coverage_vs_Xpurity_vs_Yrecall.pdf
