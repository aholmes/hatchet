# Sample data and BigQuery db structure
```
https://portal.gdc.cancer.gov/files/5ec29595-ed41-4dc8-9126-7a6bfa12e58c

isb-cgc-bq

  GDC_case_file_metadata

    aliquot2caseIDmap_current (many rows for a single case_gdc_id)
       program_name (TCGA)
       case_gdc_id (f4b69043-4a67-48e3-a4d1-72a21ae2d175)
       ...

    caseData_current (one row per case_gdc_id)
       case_gdc_id (f4b69043-4a67-48e3-a4d1-72a21ae2d175)
       program_name (TCGA)
       project_id (TCGA-BRCA)
       case_barcode (TCGA-A8-A090)

    fileData_active_current (many rows for a single case_gdc_id)
       case_gdc_id (f4b69043-4a67-48e3-a4d1-72a21ae2d175)
       file_gdc_id (5ec29595-ed41-4dc8-9126-7a6bfa12e58c)
       index_file_gdc_id (6f318373-35ec-434b-887c-9c6c262a3172)
       access (open/controlled)
       data_format (TXT/VCF/BAM/..)
       associated_entities__entity_gdc_id (patient uuid)

    GDCfileID_to_GCSurl_current
       file_gdc_id
         5ec29595-ed41-4dc8-9126-7a6bfa12e58c
         6f318373-35ec-434b-887c-9c6c262a3172
       file_gdc_url
         gs://gdc-tcga-phs000178-controlled/5ec29595-ed41-4dc8-9126-7a6bfa12e58c/TCGA-A8-A090-01A-11R-A010-13_mirna_gdc_realn.bam
         gs://gdc-tcga-phs000178-controlled/6f318373-35ec-434b-887c-9c6c262a3172/TCGA-A8-A090-01A-11R-A010-13_mirna_gdc_realn.bai
```

# build
```
docker build -t hatchet .
```

# run locally
```
docker run \
  -v /data/projects/hatchet/data/gdc:/scratch
  -it hatchet
    python -m hatchet count \
      -b /scratch/TCGA-A8-A090-01A-11R-A010-13_mirna_gdc_realn.bam \
      -t /scratch/out.txt
```

# tag and push
```
docker tag hatchet gcr.io/durable-tracer-294016/hatchet
gcloud docker -- push gcr.io/durable-tracer-294016/hatchet
```

# run pipeline
```
gcloud alpha genomics pipelines run \
  --pipeline-file pipeline.yaml \
  --inputs normalbam=gs://gdc-tcga-phs000178-controlled/BRCA/DNA/WGS/WUGSC/ILLUMINA/b9774dd35c320f70de8f2b81c15d5a98.bam \
  --inputs normalbai=gs://gdc-tcga-phs000178-controlled/BRCA/DNA/WGS/WUGSC/ILLUMINA/b9774dd35c320f70de8f2b81c15d5a98.bai \
  --inputs tumorbam=gs://gdc-tcga-phs000178-controlled/BRCA/DNA/WGS/WUGSC/ILLUMINA/2258e57e8e0af9db6969a1da86177ca7.bam \
  --inputs tumorbai=gs://gdc-tcga-phs000178-controlled/BRCA/DNA/WGS/WUGSC/ILLUMINA/2258e57e8e0af9db6969a1da86177ca7.bai \
  --outputs outputPath=gs://durable-tracer-294016-hatchetbucket/output/ \
  --logging gs://durable-tracer-294016-hatchetbucket/logging/ \
  --disk-size datadisk:1000
```

# monitor operation
```
./poll.sh ENSTsezSLhisgcyR0Zm5iisgicXNrOUQKg9wcm9kdWN0aW9uUXVldWU 20
```
