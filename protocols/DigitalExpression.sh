#MOLGENIS nodes=1 ppn=1 mem=5gb walltime=05:00:00

#Parameter mapping
#string intermediateDir
#string externalSampleID
#string project
#string sampleMergedExonTaggedBam
#string dropseqVersion
#string annotationRefFlat
#string tmpTmpDataDir
#string groupname
#string tmpName

#Load module
module load ${dropseqVersion}
module list

makeTmpDir ${sampleMergedExonTaggedBam}
tmpsampleMergedExonTaggedBam=${MC_tmpFile}

celbarcodes_present="/groups/umcg-gaf/tmp04/projects/NGS_ScRNA_test/run01/jobs/barcodes.txt"

# Number of uniq UMI's per gene and cellbarcode 

java -Xmx4g -XX:ParallelGCThreads=8 -Djava.io.tmpdir=${tmpTmpDataDir} -jar ${EBROOTDROPMINSEQ_TOOLS}/jar/dropseq.jar DigitalExpression \
EDIT_DISTANCE=2 \
CELL_BARCODE_TAG=XC \
MOLECULAR_BARCODE_TAG=XM \
GENE_EXON_TAG=GE \
OUTPUT_READS_INSTEAD=false \
MIN_SUM_EXPRESSION=0 \
MIN_BC_READ_THRESHOLD=0 \
CELL_BC_FILE=${celbarcodes_present} \
SUMMARY=${intermediateDir}/${externalSampleID}_DigitalExpression_cell_gene_number.txt \
INPUT=${sampleMergedExonTaggedBam} \
OUTPUT=${intermediateDir}/${externalSampleID}_UMIs_counts_per_gene_exon.txt


#Digital Gene Expression (Total reads)

java -Xmx4g -XX:ParallelGCThreads=8 -Djava.io.tmpdir=${tmpTmpDataDir} -jar ${EBROOTDROPMINSEQ_TOOLS}/jar/dropseq.jar DigitalExpression \
OUTPUT_READS_INSTEAD=true \
EDIT_DISTANCE=2 \
CELL_BARCODE_TAG=XC \
MOLECULAR_BARCODE_TAG=XM \
GENE_EXON_TAG=GE \
MIN_SUM_EXPRESSION=0 \
MIN_BC_READ_THRESHOLD=0 \
CELL_BC_FILE=${celbarcodes_present} \
INPUT=${sampleMergedExonTaggedBam} \
OUTPUT=${intermediateDir}/${externalSampleID}_total_readcounts_per_gene_exon_tagged.txt

#Cell Selection
java -Xmx4g -XX:ParallelGCThreads=8 -Djava.io.tmpdir=${tmpTmpDataDir} -jar ${EBROOTDROPMINSEQ_TOOLS}/jar/dropseq.jar BAMTagHistogram \
TAG=XC \
INPUT=${sampleMergedExonTaggedBam} \
OUTPUT=${intermediateDir}/${externalSampleID}_DigitalExpression_cell_readcounts.txt

echo -e "\ns Dropseq TagReadWithGeneExon finished succesfull. Moving temp files to final.\n\n"
