#!/bin/bash

MODEL_FOLDER_PATH="train"
mkdir -p ${MODEL_FOLDER_PATH}

cd ${MODEL_FOLDER_PATH}


python ../../clair3.py Train \
    --bin_fn ../train_bin \
    --ochk_prefix ${MODEL_FOLDER_PATH}/full_alignment \
    --add_indel_length True \
    --random_validation \
    --platform ilmn