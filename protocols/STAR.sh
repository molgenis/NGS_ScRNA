#MOLGENIS nodes=1 ppn=1 mem=34gb walltime=05:00:00

#Parameter mapping
#string seqType
#string lane
#string taggedUnmappedfilterFQs
#string intermediateDir
#string externalSampleID
#string project
#string groupname
#string tmpName
#string alignedSortedBam
#string StarIndex
#string	StarVersion

#Load module
module load ${StarVersion}
module list

makeTmpDir ${intermediateDir}
tmpIntermediateDir=${MC_tmpFile}

echo "## "$(date)" Start $0"
echo "ID (project-internalSampleID-lane): ${project}-${externalSampleID}-L${lane}"

uniqueID="${project}-${externalSampleID}-L${lane}"

	echo "STAR SR for ScRNA"
	 	
	 $EBROOTSTAR/bin/STAR \
	--genomeDir ${StarIndex} \
 	--runThreadN 2 \
        --readFilesIn ${taggedUnmappedfilterFQs} \
        --outSAMtype BAM SortedByCoordinate \
        --twopassMode Basic \
        --limitBAMsortRAM 45000000000 \
        --outFileNamePrefix ${tmpIntermediateDir}/${uniqueID}.bam

 	mv ${tmpIntermediateDir}/${uniqueID}.bamAligned.sortedByCoord.out.bam ${alignedSortedBam}
	mv ${tmpIntermediateDir}/${uniqueID}.bamLog.final.out ${intermediateDir}/${uniqueID}.final.log
	echo "succes moving files";


echo "## "$(date)" ##  $0 Done "
