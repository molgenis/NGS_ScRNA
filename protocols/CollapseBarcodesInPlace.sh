#MOLGENIS nodes=1 ppn=1 mem=4gb walltime=05:00:00


#Parameter mapping
#string intermediateDir
#string externalSampleID
#string project
#string	sampleMergedFinalTaggedBam
#string sampleMergedExonTaggedCollapsedBam
#string externalSampleID
#string dropseqVersion
#string annotationRefFlat
#string groupname
#string tmpName
#string cellbarcodesPresent
#list barcode2


#Load module
module load ${dropseqVersion}
module list

makeTmpDir ${sampleMergedExonTaggedCollapsedBam}
tmpsampleMergedExonTaggedCollapsedBam=${MC_tmpFile}

java -XX:ParallelGCThreads=4 -jar -Xmx3g ${EBROOTDROPMINSEQ_TOOLS}/jar/dropseq.jar CollapseBarcodesInPlace \
INPUT=${sampleMergedFinalTaggedBam} \
OUTPUT=${tmpsampleMergedExonTaggedCollapsedBam} \
PRIMARY_BARCODE=XC \
OUT_BARCODE=ZC \
EDIT_DISTANCE=1 \
READ_QUALITY=10 \
FILTER_PCR_DUPLICATES=false \
FIND_INDELS=true \
MIN_NUM_READS_CORE=3000


echo -e "\ns Dropseq CollapseBarcodesInPlace finished succesfull. Moving temp files to final.\n\n"
mv -f ${tmpsampleMergedExonTaggedCollapsedBam} ${sampleMergedExonTaggedCollapsedBam}
