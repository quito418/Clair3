## PacBio HiFi Variant Calling Quick Demo
Here is a quick demo for the PacBio HiFi variant calling using GIAB HG003 chromosome 20 data.

```bash
Platform:   PacBio HiFi
Sample:     GIAB HG003
Coverage:   ~35x
Aligner:    pbmm2
Reference:  GRCh38_no_alt
Region:     chr20:100000-300000
Chemistry:  CCS-15kb Sequel II, chemistry 2.0
```

**Run Clair3:**

```bash
PLATFORM='hifi'
INPUT_DIR="${HOME}/clair3_pacbio_hifi_quickDemo"
OUTPUT_DIR="${INPUT_DIR}/output"
THREADS=4
BIN_VERSION="v0.1"

## Create local directory structure
mkdir -p ${INPUT_DIR}
mkdir -p ${OUTPUT_DIR}

# Download quick demo data
#GRCh38_no_alt Reference
wget -P ${INPUT_DIR} http://www.bio8.cs.hku.hk/clair3/demo/quick_demo/pacbio_hifi/GRCh38_no_alt_chr20.fa
wget -P ${INPUT_DIR} http://www.bio8.cs.hku.hk/clair3/demo/quick_demo/pacbio_hifi/GRCh38_no_alt_chr20.fa.fai
# BAM chr20:100000-300000
wget -P ${INPUT_DIR} http://www.bio8.cs.hku.hk/clair3/demo/quick_demo/pacbio_hifi/HG003_chr20_demo.bam
wget -P ${INPUT_DIR} http://www.bio8.cs.hku.hk/clair3/demo/quick_demo/pacbio_hifi/HG003_chr20_demo.bam.bai
# GIAB Truth VCF and BED
wget -P ${INPUT_DIR} http://www.bio8.cs.hku.hk/clair3/demo/quick_demo/pacbio_hifi/HG003_GRCh38_chr20_v4.2.1_benchmark.vcf.gz
wget -P ${INPUT_DIR} http://www.bio8.cs.hku.hk/clair3/demo/quick_demo/pacbio_hifi/HG003_GRCh38_chr20_v4.2.1_benchmark.vcf.gz.tbi
wget -P ${INPUT_DIR} http://www.bio8.cs.hku.hk/clair3/demo/quick_demo/pacbio_hifi/HG003_GRCh38_chr20_v4.2.1_benchmark_noinconsistent.bed

REF="GRCh38_no_alt_chr20.fa"
BAM="HG003_chr20_demo.bam"
BASELINE_VCF_FILE_PATH="HG003_GRCh38_chr20_v4.2.1_benchmark.vcf.gz"
BASELINE_BED_FILE_PATH="HG003_GRCh38_chr20_v4.2.1_benchmark_noinconsistent.bed"
OUTPUT_VCF_FILE_PATH="merge_output.vcf.gz"

CONTIGS='chr20'
START_POS='100000'
END_POS="300000"
echo -e "${CONTIGS}\t${START_POS}\t${END_POS}" > ${INPUT_DIR}/quick_demo.bed

# Run Clair3 using one command
docker run \
  -v ${INPUT_DIR}:${INPUT_DIR} \
  -v ${OUTPUT_DIR}:${OUTPUT_DIR} \
  hku-bal/clair3:"${BIN_VERSION}" \
  /opt/bin/run_clair3.sh \
  --bam_fn=${INPUT_DIR}/${BAM} \
  --ref_fn=${INPUT_DIR}/${REF} \
  --threads=${THREADS} \
  --platform=${PLATFORM} \
  --model_path="/opt/models/${PLATFORM}" \
  --output=${OUTPUT_DIR} \
  --bed_fn=${INPUT_DIR}/quick_demo.bed
```

**Run hap.py for benchmarking (Optional)**

```bash
# Run hap.py
docker run \
-v "${INPUT_DIR}":"${INPUT_DIR}" \
-v "${OUTPUT_DIR}":"${OUTPUT_DIR}" \
jmcdani20/hap.py:v0.3.12 /opt/hap.py/bin/hap.py \
${INPUT_DIR}/${BASELINE_VCF_FILE_PATH} \
${OUTPUT_DIR}/${OUTPUT_VCF_FILE_PATH} \
-f "${INPUT_DIR}/${BASELINE_BED_FILE_PATH}" \
-r "${INPUT_DIR}/${REF}" \
-o "${OUTPUT_DIR}/happy" \
-l ${CONTIGS}:${START_POS}-${END_POS} \
--engine=vcfeval \
--threads="${THREADS}" \
--pass-only
```

**Hap.py Expected output:**

|   Type    | TRUTH.TP | TRUTH.FN | QUERY.FP | METRIC.Recall | METRIC.Precision | METRIC.F1-Score |
| :-------: | :------: | :------: | :------: | :-----------: | :--------------: | :-------------: |
| **INDEL** |    59    |    0     |    0     |      1.0      |       1.0        |       1.0       |
|  **SNP**  |   402    |    0     |    0     |      1.0      |       1.0        |       1.0       |

Run all commands above:

```bash
cd ${HOME}
wget "http://www.bio8.cs.hku.hk/clair3/demo/clair3_hifi_quick_demo.sh"
chmod +x clair3_hifi_quick_demo.sh
./clair3_hifi_quick_demo.sh
```

Check the results using `less ${HOME}/clair3_pacbio_hifi_quickDemo/output/merge_output.vcf.gz`