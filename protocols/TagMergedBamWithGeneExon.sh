#MOLGENIS nodes=1 ppn=1 mem=4gb walltime=05:00:00


#Parameter mapping
#string intermediateDir
#string externalSampleID
#string project
#string sampleLanesMergedBam
#string sampleMergedExonTaggedBam
#string externalSampleID
#string dropseqVersion
#string annotationRefFlat
#string groupname
#string tmpName


#Load module
module load ${dropseqVersion}
module list

makeTmpDir ${sampleMergedExonTaggedBam}
tmpsampleMergedExonTaggedBam=${MC_tmpFile}

java -XX:ParallelGCThreads=4 -jar -Xmx3g ${EBROOTDROPMINSEQ_TOOLS}/jar/dropseq.jar TagReadWithGeneExon \
ANNOTATIONS_FILE=${annotationRefFlat} \
TAG=GE \
CREATE_INDEX=true \
INPUT=${sampleLanesMergedBam} \
OUTPUT=${tmpsampleMergedExonTaggedBam}

echo -e "\ns Dropseq TagReadWithGeneExon finished succesfull. Moving temp files to final.\n\n"
mv -f ${tmpsampleMergedExonTaggedBam} ${sampleMergedExonTaggedBam}
