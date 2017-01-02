#MOLGENIS nodes=1 ppn=1 mem=1gb walltime=05:00:00


#Parameter mapping
#string peEnd1BarcodeFqGz
#string peEnd2BarcodeFqGz
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

#clipping atribute XT?

 java -Xmx500m -jar ${EBROOTPICARD}/picard.jar SamToFastq \
 INPUT=${taggedUnmappedBam} \
 FASTQ=${taggedfilterFQs}

 echo -e "\nSamToFastq finished succesfull. Moving temp files to final.\n\n"
 mv -f ${tmptaggedUnmappedfilterFQs} ${taggedUnmappedfilterFQs}

