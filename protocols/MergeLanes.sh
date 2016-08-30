#MOLGENIS walltime=23:59:00 mem=8gb ppn=1

#Parameter mapping
#string stage
#string checkStage
#string picardVersion
#string mergeSamFilesJar
#string sampleLanesMergedBam
#string tempDir
#string tmpDataDir
#list externalSampleID,sampleMergedBam
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

for Bam in "${sampleMergedBam[@]}"
do
        array_contains INPUTS "I=$Bam" || INPUTS+=("I=$Bam")    # If bamFile does not exist in array add it
done


makeTmpDir ${sampleLanesMergedBam}
tmpSampleLanesMergedBam=${MC_tmpFile}

#Load Picard module
${stage} ${picardVersion}
${checkStage}


	java -XX:ParallelGCThreads=4 -jar -Xmx6g ${EBROOTPICARD}/${picardJar} MergeSamFiles \
	${INPUTS[@]} \
	SORT_ORDER=coordinate \
	CREATE_INDEX=true \
	USE_THREADING=true \
	TMP_DIR=${tempDir} \
	MAX_RECORDS_IN_RAM=6000000 \
	VALIDATION_STRINGENCY=LENIENT \
	OUTPUT=${tmpSampleLanesMergedBam}


	mv ${tmpSampleLanesMergedBam} ${sampleLanesMergedBam}
