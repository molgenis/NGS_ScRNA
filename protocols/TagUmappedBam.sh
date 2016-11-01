#MOLGENIS nodes=1 ppn=1 mem=5gb walltime=05:00:00

#Parameter mapping
#string intermediateDir
#string externalSampleID
#string project
#string unMappedBam
#string	filePrefix
#string tempDir
#string taggedUnmappedBam
#string dropseqVersion
#string groupname
#string tmpName


#Load module
module load ${dropseqVersion}
module list

makeTmpDir ${taggedUnmappedBam}
tmptaggedUnmappedBam=${MC_tmpFile}


# Stage 1: pre-alignment tag and trim

tag_cells="java -jar ${EBROOTDROPMINSEQ_TOOLS}/jar/dropseq.jar TagBamWithReadSequenceExtended \
SUMMARY=${intermediateDir}/${filePrefix}_${externalSampleID}_unaligned_tagged_Cellular.bam_summary.txt \
BASE_RANGE=8-17 \
BASE_QUALITY=10 \
BARCODED_READ=1 \
DISCARD_READ=false \
TAG_NAME=XC \
TMP_DIR=${tempDir} \
NUM_BASES_BELOW_QUALITY=1 \
INPUT=${unMappedBam} \
COMPRESSION_LEVEL=0"

#BASE_RANGE=8-17 when UMI is not trimmed off yet, 1-10 when it is trimmed off (turn off tag_molecules !!)
#Activate command lines below when poolbarcode in read 3 is not removed and marked yet
#tag_pools="${EBROOTDROPMINSEQ_TOOLS}/TagBamWithReadSequenceExtended SUMMARY=${intermediateDir}/unaligned_tagged_Pool.bam_summary_${filePrefix}_${externalSampleID}.txt \
#BASE_RANGE=1-8 BASE_QUALITY=10 BARCODED_READ=3 DISCARD_READ=true TAG_NAME=XP NUM_BASES_BELOW_QUALITY=1"

#Tag UMI's

tag_molecules="java -jar ${EBROOTDROPMINSEQ_TOOLS}/jar/dropseq.jar TagBamWithReadSequenceExtended \
SUMMARY=${intermediateDir}/${filePrefix}_${externalSampleID}_unaligned_tagged_Molecular.bam_summary.txt \
BASE_RANGE=1-7 \
BASE_QUALITY=10 \
TMP_DIR=${tempDir} \
BARCODED_READ=1 \
DISCARD_READ=true \
TAG_NAME=XM \
NUM_BASES_BELOW_QUALITY=1 \
COMPRESSION_LEVEL=0"

filter_bam="java -jar ${EBROOTDROPMINSEQ_TOOLS}/jar/dropseq.jar FilterBAM \
TAG_REJECT=XQ \
TMP_DIR=${tempDir} \
COMPRESSION_LEVEL=0"

trim_starting_sequence="java -Xmx4g -XX:ParallelGCThreads=1 -Djava.io.tmpdir=//groups/umcg-gaf//tmp04//temp/ -jar ${EBROOTDROPMINSEQ_TOOLS}/jar/dropseq.jar TrimStartingSequence \
OUTPUT_SUMMARY=${intermediateDir}/${filePrefix}_${externalSampleID}_adapter_trimming_report.txt \
SEQUENCE=AAGCAGTGGTATCAACGCAGAGTAC \
MISMATCHES=0 \
NUM_BASES=10 \
TMP_DIR=${tempDir} \
COMPRESSION_LEVEL=0"

#trim_pool_sequence="java -jar ${EBROOTDROPMINSEQ_TOOLS}/jar/dropseq.jar TrimStartingSequence \
#OUTPUT_SUMMARY=${intermediateDir}/${filePrefix}_${externalSampleID}_adapter_trimming_report.txt \
#SEQUENCE=AAGCAGTGGTATCAACGCAGAGTAC \
#MISMATCHES=0 \
TMP_DIR=${tempDir} \
#NUM_BASES=8 \
#COMPRESSION_LEVEL=0"

trim_poly_a="java -jar ${EBROOTDROPMINSEQ_TOOLS}/jar/dropseq.jar PolyATrimmer \
OUTPUT_SUMMARY=${intermediateDir}/${filePrefix}_${externalSampleID}_polyA_trimming_report.txt \
MISMATCHES=0 \
NUM_BASES=6 \
TMP_DIR=${tempDir} \
TRIM_TAG=XA \
MAX_POLY_A_ERROR_RATE=0.1 \
MIN_POLY_A_LENGTH=6 \
COMPRESSION_LEVEL=0"

# Run commands
$tag_cells OUTPUT=/dev/stdout | \
$tag_molecules INPUT=/dev/stdin OUTPUT=/dev/stdout | \
$filter_bam INPUT=/dev/stdin OUTPUT=/dev/stdout | \
$trim_starting_sequence INPUT=/dev/stdin OUTPUT=/dev/stdout | \
$trim_poly_a INPUT=/dev/stdin OUTPUT=${tmptaggedUnmappedBam}


echo -e "\ntagUnmappedBam finished succesfull. Moving temp files to final.\n\n"
mv -f ${tmptaggedUnmappedBam} ${taggedUnmappedBam}

