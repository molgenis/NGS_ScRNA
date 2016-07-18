#MOLGENIS walltime=23:59:00 mem=8gb ppn=1

#Parameter mapping
#string stage
#string checkStage
#string picardVersion
#string mergeSamFilesJar
#string taggedUnmappedBam
#string alignedSortedBam
#string sampleMergedBam
#string tempDir
#string tmpDataDir
#string externalSampleID
#string project
#string intermediateDir
#string picardJar
#string indexSpecies
#string groupname
#string tmpName

sleep 5

#Function to check if array contains value
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

makeTmpDir ${sampleMergedBam}
tmpSampleMergedBam=${MC_tmpFile}

#Load Picard module
${stage} ${picardVersion}
${checkStage}

	java -XX:ParallelGCThreads=4 -jar -Xmx6g ${EBROOTPICARD}/${picardJar} MergeBamAlignment \
	REFERENCE_SEQUENCE=${indexSpecies} \
	UNMAPPED_BAM=${taggedUnmappedBam} \
	ALIGNED_BAM=${alignedSortedBam} \
	INCLUDE_SECONDARY_ALIGNMENTS=false \
	PAIRED_RUN=false \
	TMP_DIR=${tempDir} \
	MAX_RECORDS_IN_RAM=6000000 \
	VALIDATION_STRINGENCY=LENIENT \
	OUTPUT=${tmpSampleMergedBam}

	echo -e "\nsampleMergedBam finished succesfull. Moving temp files to final.\n\n"
	mv ${tmpSampleMergedBam} ${sampleMergedBam}


