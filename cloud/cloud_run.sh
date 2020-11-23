#!/bin/bash

dsub \
  --provider google-v2 \
  --project project_id \
  --regions us-east1 \
  --logging "gs://hatchet_bucket/logging" \
  --disk-size 1000 \
  --name "hatchet_run_00" \
  --image gcr.io/durable-tracer-294016/hatchet \
  --input NORMALBAM="gs://gdc-tcga-phs000178-controlled/BRCA/DNA/WGS/WUGSC/ILLUMINA/b9774dd35c320f70de8f2b81c15d5a98.bam" \
  --input NORMALBAI="gs://gdc-tcga-phs000178-controlled/BRCA/DNA/WGS/WUGSC/ILLUMINA/b9774dd35c320f70de8f2b81c15d5a98.bam.bai" \
  --input TUMORBAM1="gs://gdc-tcga-phs000178-controlled/BRCA/DNA/WGS/WUGSC/ILLUMINA/2258e57e8e0af9db6969a1da86177ca7.bam" \
  --input TUMORBAI1="gs://gdc-tcga-phs000178-controlled/BRCA/DNA/WGS/WUGSC/ILLUMINA/2258e57e8e0af9db6969a1da86177ca7.bam.bai" \
  --output-recursive OUTPUT_FOLDER="gs://hatchet_bucket/output" \
  --script "_run.sh" \
  --wait