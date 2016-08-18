#MOLGENIS nodes=1 ppn=1 mem=2gb walltime=05:00:00


#Parameter mapping
#string intermediateDir
#string externalSampleID
#string project
#string taggedUnmappedBam
#string taggedUnmappedfilterFQs
#string picardVersion
#string groupname
#string tmpName


#Load module
module load ${picardVersion}
module list

 makeTmpDir ${taggedUnmappedfilterFQs}
 tmptaggedUnmappedfilterFQs=${MC_tmpFile}

 java -Xmx1g -jar ${EBROOTPICARD}/picard.jar SamToFastq \
 INPUT=${taggedUnmappedBam} \
 FASTQ=${tmptaggedUnmappedfilterFQs}

 echo -e "\nBamToFastq finished succesfull. Moving temp files to final.\n\n"
 mv -f ${tmptaggedUnmappedfilterFQs} ${taggedUnmappedfilterFQs}

