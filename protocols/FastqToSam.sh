#MOLGENIS nodes=1 ppn=1 mem=6gb walltime=05:00:00


#Parameter mapping
#string peEnd1BarcodeFqGz
#string peEnd2BarcodeFqGz
#string intermediateDir
#string externalSampleID
#string project
#string unMappedBam
#string picardVersion
#string groupname
#string tmpName
#string tempDir


#Load module
module load ${picardVersion}
module list

makeTmpDir ${unMappedBam}
tmpunMappedBam=${MC_tmpFile}

	java -Xmx5G -jar ${EBROOTPICARD}/picard.jar FastqToSam \
	FASTQ=${peEnd1BarcodeFqGz} \
	FASTQ2=${peEnd2BarcodeFqGz} \
	OUTPUT=${tmpunMappedBam} \
	SAMPLE_NAME=${externalSampleID} \
	TMP_DIR=${tempDir} \
	PLATFORM=illumina

echo -e "\nFastqToSam finished succesfull. Moving temp files to final.\n\n"
mv -f ${tmpunMappedBam} ${unMappedBam}

