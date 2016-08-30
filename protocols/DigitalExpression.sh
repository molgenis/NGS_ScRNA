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
#string celbarcodesPresent
#string UmiCountsPerGeneExon
#string TotalCountsPerGeneExon
#string CellReadcounts
#list barcode2

array_contains () {
    local array="$1[@]"
    local seeking=$2
    local in=1
    for element in "${!array-}"; do
        if [[ "$element" == "$seeking" ]]; then
            in=0
            break
        fi
    done
    return $in
}

#Load module
module load ${dropseqVersion}
module list

makeTmpDir ${sampleMergedExonTaggedBam}
tmpsampleMergedExonTaggedBam=${MC_tmpFile}


for barcode in "${barcode2[@]}"
do
	array_contains INPUTS "$barcode" || INPUTS+=("$barcode")    # If bamFile does not exist in array add it
done


for cellBarcode in "${INPUTS[@]}" 
do
        echo -e "${cellBarcode}" >> ${celbarcodesPresent}
done


# Number of uniq UMI's per gene and cellbarcode 

java -Xmx4g -XX:ParallelGCThreads=8 -Djava.io.tmpdir=${tmpTmpDataDir} -jar ${EBROOTDROPMINSEQ_TOOLS}/jar/dropseq.jar DigitalExpression \
EDIT_DISTANCE=2 \
CELL_BARCODE_TAG=XC \
MOLECULAR_BARCODE_TAG=XM \
GENE_EXON_TAG=GE \
OUTPUT_READS_INSTEAD=false \
MIN_SUM_EXPRESSION=0 \
MIN_BC_READ_THRESHOLD=0 \
CELL_BC_FILE=${celbarcodesPresent} \
SUMMARY=${intermediateDir}/${externalSampleID}_DigitalExpression_cell_gene_number.txt \
INPUT=${sampleMergedExonTaggedBam} \
OUTPUT=${UmiCountsPerGeneExon}
${intermediateDir}/${externalSampleID}_UMIs_counts_per_gene_exon.txt


#Digital Gene Expression (Total reads)

java -Xmx4g -XX:ParallelGCThreads=8 -Djava.io.tmpdir=${tmpTmpDataDir} -jar ${EBROOTDROPMINSEQ_TOOLS}/jar/dropseq.jar DigitalExpression \
OUTPUT_READS_INSTEAD=true \
EDIT_DISTANCE=2 \
CELL_BARCODE_TAG=XC \
MOLECULAR_BARCODE_TAG=XM \
GENE_EXON_TAG=GE \
MIN_SUM_EXPRESSION=0 \
MIN_BC_READ_THRESHOLD=0 \
CELL_BC_FILE=${celbarcodesPresent} \
INPUT=${sampleMergedExonTaggedBam} \
OUTPUT=${TotalCountsPerGeneExon}
${intermediateDir}/${externalSampleID}_total_readcounts_per_gene_exon_tagged.txt

#Cell Selection
java -Xmx4g -XX:ParallelGCThreads=8 -Djava.io.tmpdir=${tmpTmpDataDir} -jar ${EBROOTDROPMINSEQ_TOOLS}/jar/dropseq.jar BAMTagHistogram \
TAG=XC \
INPUT=${sampleMergedExonTaggedBam} \
OUTPUT=${CellReadcounts}

${intermediateDir}/${externalSampleID}_DigitalExpression_cell_readcounts.txt

echo -e "\ns Dropseq TagReadWithGeneExon finished succesfull. Moving temp files to final.\n\n"
