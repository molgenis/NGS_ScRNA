#MOLGENIS nodes=1 ppn=1 mem=10gb walltime=01:00:00

#Parameter mapping
#string seqType
#string lane
#string taggedUnmappedfilterFQs
#string alignedSortedBam
#string intermediateDir
#string kallistoVersion
#string picardVersion
#string externalSampleID
#string kallistoIndex
#string project
#string tempDir
#string groupname
#string tmpName

#Load module
module load ${kallistoVersion}
module load ${picardVersion}
module list

makeTmpDir ${intermediateDir}
tmpIntermediateDir=${MC_tmpFile}

echo "## "$(date)" Start $0"
echo "ID (project-internalSampleID-lane): ${project}-${externalSampleID}-L${lane}"

mkdir -p ${intermediateDir}/Kallisto/

uniqueID="${project}-${externalSampleID}-L${lane}"

	echo "Kallisto SR for ScRNA"
	 	
	 kallisto pseudo \
	-i ${kallistoIndex} \
	--pseudobam \
        --single \
        -l 50 -s 10 \
	-o ${tmpIntermediateDir}/ \
	${taggedUnmappedfilterFQs} > ${tmpIntermediateDir}/${uniqueID}.sam


	java -XX:ParallelGCThreads=4 -jar -Xmx6g ${EBROOTPICARD}/picard.jar SortSam \
	INPUT=${tmpIntermediateDir}/${uniqueID}.sam \
	OUTPUT=${tmpIntermediateDir}/${uniqueID}.sorted.bam \
 	SO=queryname \
	CREATE_INDEX=true \
	VALIDATION_STRINGENCY=LENIENT \
	TMP_DIR=${tempDir}



#	cd ${tmpIntermediateDir}/${uniqueID}

#	md5sum abundance.h5 > abundance.h5.md5
#	md5sum run_info.json > run_info.json.md5
#	md5sum abundance.tsv > abundance.tsv.md5
 #	cd -

#	rm -rf ${intermediateDir}/Kallisto/${uniqueID} 
	mv -f ${tmpIntermediateDir}/${uniqueID}.sorted.bam  ${alignedSortedBam}
	echo "succes moving files";


echo "## "$(date)" ##  $0 Done "
