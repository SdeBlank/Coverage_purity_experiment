#! /bin/python

import re
from sys import argv
sv_bed = open(argv[2],'w')

n = 1
with( open(argv[1],'r')) as denovo_vcf_file:
    for line in denovo_vcf_file:
        line = line.rstrip()
        columns = line.split("\t")
        if not line.startswith("#"):
            first_chr = columns[0]
            start = str(int(columns[1])-5000)
            start2 = str(int(columns[1])+5000)
            sv_bed.write("\t".join([first_chr,start,start2,"SV_"+str(n)+"_start"])+"\n")

            alt_match = re.search("^(\w*\]|\w*\[)(\w+):(\d+)(\]\w*|\[\w*)$", columns[4])
            end_match = re.search("END=(\d+)(;|$)", columns[7])
            if alt_match:
                second_chr = alt_match.group(2)
                end = alt_match.group(3)
            elif end_match:
                second_chr = first_chr
                end = end_match.group(1)

            end1 = str(int(end)-1000)
            end2 = str(int(end)+1000)
            sv_bed.write("\t".join([second_chr,end1,end2,"SV_"+str(n)+"_end"])+"\n")
            n += 1
sv_bed.close() 
