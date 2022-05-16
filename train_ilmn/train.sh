#!/bin/bash
source env.sh
MODEL_FOLDER_PATH="train"
mkdir -p ${MODEL_FOLDER_PATH}

python ${CLAIR3} Train \
    --bin_fn ${BINS_FOLDER_PATH} \
    --ochk_prefix ${MODEL_FOLDER_PATH}/full_alignment \
    --add_indel_length True \
    --random_validation \
    --platform ilmn