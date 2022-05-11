#!/bin/bash

# Create full-alignment tensors for model training
pypy3 ../clair3.py CreateTrainingTensor \
    --bam_fn /data/data_HG00X/HG001.hiseqx.pcr-free.40x.dedup.grch38.bam \
    --ref_fn /data/human_ref/hg38/Homo_sapiens_assembly38.fasta \
    --var_fn var_out \
    --bin_fn tensor_bin \
    --ctgName chr22 \
    --samtools `which samtools` \
    --bed_fn /data/data_HG00X/HG001_GRCh38_1_22_v4.2.1_benchmark.bed \
    --phasing_info_in_bam \
    --add_no_phasing_data_training \
    --allow_duplicate_chr_pos \
    --platform ilmn \
    --shuffle \
    --maximum_non_variant_ratio 1

# Create full-alignment tensors for model training
# ${PARALLEL} --joblog ${DATASET_FOLDER_PATH}/create_tensor_full_alignment.log -j${THREADS_LOW} \
# "${PYPY} ${CLAIR3} CreateTrainingTensor \
#     --bam_fn ${PHASE_BAM_PATH}/{2}_{3}_{1}.bam \
#     --ref_fn {5} \
#     --var_fn ${VAR_OUTPUT_PATH}/var_{2}_{3}_{1} \
#     --bin_fn ${TENSOR_CANDIDATE_PATH}/tensor_{2}_{3}_{1}_{7} \
#     --ctgName ${CHR_PREFIX}{1} \
#     --samtools ${SAMTOOLS} \
#     --extend_bed ${SPLIT_BED_PATH}/{2}_{3}_{1} \
#     --full_aln_regions ${CANDIDATE_BED_PATH}/{2}_{3}_{1}_{7} \
#     --bed_fn {6} \
#     --phasing_info_in_bam \
#     --add_no_phasing_data_training \
#     --allow_duplicate_chr_pos \
#     --platform ${PLATFORM} \
#     --shuffle \
#     --maximum_non_variant_ratio ${MAXIMUM_NON_VARIANT_RATIO} \
#     --chunk_id {7} \
#     --chunk_num ${chunk_num}" ::: ${CHR[@]} ::: ${ALL_SAMPLE[@]} :::+ ${DEPTHS[@]} :::+ ${ALL_UNPHASED_BAM_FILE_PATH[@]} :::+ ${ALL_REFERENCE_FILE_PATH[@]} :::+ ${ALL_BED_FILE_PATH[@]} ::: ${CHUNK_LIST[@]}