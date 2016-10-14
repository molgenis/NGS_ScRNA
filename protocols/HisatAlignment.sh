#MOLGENIS nodes=1 ppn=8 mem=12gb walltime=05:00:00

#string project
#string stage
#string checkStage
#string hisatIndex
#string intermediateDir
#string hisatVersion
#string externalSampleID
#string samtoolsVersion
#string picardVersion
#string tempDir
#string filePrefix
#string picardJar
#string seqType
#string groupname
#string	tmpName
#string taggedUnmappedfilterFQs
#string alignedSam
#string alignedSortedBam
#string alignedSortedBai
#string picardVersion
#string groupname
#string tmpName

makeTmpDir ${alignedSam}
tmpalignedSam=${MC_tmpFile}

makeTmpDir ${alignedSortedBam}
tmpalignedSortedBam=${MC_tmpFile}

makeTmpDir ${alignedSortedBai}
tmpalignedSortedBai=${MC_tmpFile}


#Load modules
${stage} ${hisatVersion}
${stage} ${samtoolsVersion}
${stage} ${picardVersion}

#check modules
${checkStage}

echo "## "$(date)" Start $0"

	hisat -x ${hisatIndex} \
	-U ${taggedUnmappedfilterFQs} \
	-p 8 \
	-S ${tmpalignedSam} > ${intermediateDir}/${filePrefix}_${externalSampleID}.hisat.log 2>&1


java -XX:ParallelGCThreads=4 -jar -Xmx6g ${EBROOTPICARD}/${picardJar} SortSam \
	INPUT=${tmpalignedSam} \
	OUTPUT=${tmpalignedSortedBam} \
 	SORT_ORDER=queryname \
	CREATE_INDEX=true \
	VALIDATION_STRINGENCY=LENIENT \
	TMP_DIR=${tempDir}

	echo "returncode: $?";
	mv ${tmpalignedSortedBam} ${alignedSortedBam}
	echo "succes moving files";

	echo "## "$(date)" ##  $0 Done "
