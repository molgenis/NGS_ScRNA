#MOLGENIS nodes=1 ppn=1 mem=4gb walltime=05:00:00


#Parameter mapping
#string intermediateDir
#string externalSampleID
#string project
#string	sampleMergedExonGenTaggedBam
#string	sampleMergedFinalTaggedBam
#string externalSampleID
#string dropseqVersion
#string annotationRefFlat
#string groupname
#string tmpName

#Load module
module load ${dropseqVersion}
module list

makeTmpDir ${sampleMergedFinalTaggedBam}
tmpsampleMergedFinalTaggedBam=${MC_tmpFile}

# TagReadWithGeneExon ( GE )
java -XX:ParallelGCThreads=4 -jar -Xmx3g ${EBROOTDROPMINSEQ_TOOLS}/jar/dropseq.jar TagReadWithGeneExon \
ANNOTATIONS_FILE=${annotationRefFlat} \
TAG=GE \
CREATE_INDEX=true \
INPUT=${sampleMergedExonGenTaggedBam} \
OUTPUT=${tmpsampleMergedFinalTaggedBam}


echo -e "\ns Dropseq TagReadWithGeneExon finished succesfull. Moving temp files to final.\n\n"
mv -f ${tmpsampleMergedFinalTaggedBam} ${sampleMergedFinalTaggedBam}
