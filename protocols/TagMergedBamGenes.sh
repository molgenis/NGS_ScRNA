#MOLGENIS nodes=1 ppn=1 mem=4gb walltime=05:00:00


#Parameter mapping
#string intermediateDir
#string externalSampleID
#string project
#string sampleMergedExonTaggedBam
#string sampleMergedExonGenTaggedBam
#string annotationGenIntervalList
#string externalSampleID
#string dropseqVersion
#string annotationRefFlat
#string groupname
#string tmpName


#Load module
module load ${dropseqVersion}
module list

makeTmpDir ${sampleMergedExonGenTaggedBam}
tmpsampleMergedExonGenTaggedBam=${MC_tmpFile}


# TagReadWithInterval ( XG )

java -XX:ParallelGCThreads=4 -jar -Xmx3g ${EBROOTDROPMINSEQ_TOOLS}/jar/dropseq.jar TagReadWithInterval \
INPUT=${sampleMergedExonTaggedBam} \
OUTPUT=${sampleMergedExonGenTaggedBam} \
COMPRESSION_LEVEL=0 \
TAG=XG \
LOCI=${annotationGenIntervalList}

echo -e "\ns Dropseq TagReadWithInterval Genes finished succesfull. Moving temp files to final.\n\n"
#mv -f ${tmpsampleMergedExonGenTaggedBam} ${sampleMergedExonGenTaggedBam}
