#MOLGENIS nodes=1 ppn=1 mem=4gb walltime=05:00:00

#Parameter mapping
#string intermediateDir
#string externalSampleID
#string project
#string sampleLanesMergedBam
#string sampleMergedExonTaggedBam
#string annotationExonIntervalList
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


# TagReadWithInterval ( XE )
java -XX:ParallelGCThreads=4 -jar -Xmx3g ${EBROOTDROPMINSEQ_TOOLS}/jar/dropseq.jar TagReadWithInterval \
INPUT=${sampleLanesMergedBam}  \
OUTPUT=${sampleMergedExonTaggedBam} \
COMPRESSION_LEVEL=0 \
TAG=XE \
LOCI=${annotationExonIntervalList}

echo -e "\ns Dropseq TagReadWithInterval Exons finished succesfull. Moving temp files to final.\n\n"
#mv -f ${tmpsampleMergedExonTaggedBam} ${sampleMergedExonTaggedBam}
