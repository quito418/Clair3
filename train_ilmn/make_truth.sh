#!/bin/bash

# Create truth
pypy3 ../clair3.py GetTruth \
    --vcf_fn /data/data_HG00X/HG001_GRCh38_1_22_v4.2.1_benchmark.vcf.gz \
    --ctgName chr22 \
    --var_fn var_out 