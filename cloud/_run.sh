#!/usr/bin/env bash

# -------------------------------------------------------------
# This script is meant to be run INSIDE the docker container by
# the Google Pipelines API
# -------------------------------------------------------------

set -e
set -o xtrace

NORMAL=$(/bin/ls /mnt/data/normal/*.bam)
NORMAL=${NORMAL[0]}
BAMS=""
ALLNAMES="NORMAL"

for file in $(/bin/ls /mnt/data/tumor/*.bam); do
  echo $file
  BAMS+=" ${file}"
  filename=$(basename -- "$file")
  filename="${filename%.*}"
  ALLNAMES+=" ${filename}"
done

OUTPUT_FOLDER=/mnt/data/output/
BIN=${OUTPUT_FOLDER}bin/
BAF=${OUTPUT_FOLDER}baf/
BB=${OUTPUT_FOLDER}bb/
BBC=${OUTPUT_FOLDER}bbc/
ANA=${OUTPUT_FOLDER}analysis/
RES=${OUTPUT_FOLDER}results/
EVA=${OUTPUT_FOLDER}evaluation/

mkdir -p ${BIN} ${BAF} ${BB} ${BBC} ${ANA} ${RES} ${EVA}
echo "test" > ${BIN}/empty.txt
echo "test" > ${BAF}/empty.txt
echo "test" > ${BB}/empty.txt
echo "test" > ${BBC}/empty.txt
echo "test" > ${ANA}/empty.txt
echo "test" > ${RES}/empty.txt
echo "test" > ${EVA}/empty.txt

python -m hatchet checkme -N ${NORMAL} -T ${BAMS} -S ${ALLNAMES} -b ${BINSIZE} -o ${BIN}out.txt
#python -m hatchet binBAM -N ${NORMAL} -T ${BAMS} -S ${ALLNAMES} -b ${BINSIZE} -O ${BIN}normal.bin -o ${BIN}bulk.bin &> ${BIN}bins.log
#python -m hatchet deBAF -N ${NORMAL} -T ${BAMS} -S ${ALLNAMES} -O ${BAF}normal.baf -o ${BAF}bulk.baf &> ${BAF}bafs.log
#python -m hatchet comBBo -c ${BIN}normal.bin -C ${BIN}bulk.bin -B ${BAF}bulk.baf > ${BB}bulk.bb
#python -m hatchet cluBB ${BB}bulk.bb -o ${BBC}bulk.seg -O ${BBC}bulk.bbc

cd ${ANA}
#python -m hatchet BBot -c RD ${BBC}bulk.bbc
#python -m hatchet BBot -c CRD ${BBC}bulk.bbc
#python -m hatchet BBot -c BAF ${BBC}bulk.bbc
#python -m hatchet BBot -c BB ${BBC}bulk.bbc
#python -m hatchet BBot -c CBB ${BBC}bulk.bbc

# ------------------------------------------------------
# Commented out till the solver works inside a container
# ------------------------------------------------------
# cd ${RES}
# python -m hatchet solve -i ${BBC}bulk &> >(tee >(grep -v Progress > hatchet.log))

# cd ${EVA}
# python -m hatchet BBeval ${RES}/best.bbc.ucn
