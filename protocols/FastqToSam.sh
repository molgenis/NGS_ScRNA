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


#Load module
module load ${picardVersion}
module list

makeTmpDir ${unMappedBam}
tmpunMappedBam=${MC_tmpFile}

	java -Xmx5G -jar ${EBROOTPICARD}/picard.jar FastqToSam \
	FASTQ=/groups/umcg-gaf/tmp04/rawdata/ngs/run_0006_AH5W7TAFXX/lane1_GGACTCCT_S1_L001_R1_001.fq.gz \
	FASTQ2=/groups/umcg-gaf/tmp04/rawdata/ngs/run_0006_AH5W7TAFXX/lane1_GGACTCCT_S1_L001_R2_001.fq.gz \
	OUTPUT=${tmpunMappedBam} \
	SAMPLE_NAME=${externalSampleID} \
	PLATFORM=illumina
	

	echo -e "\nFastqToSam finished succesfull. Moving temp files to final.\n\n"
	mv -f ${tmpunMappedBam} ${unMappedBam}

