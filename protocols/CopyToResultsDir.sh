#MOLGENIS walltime=23:59:00 nodes=1 cores=1 mem=4gb

#Parameter mapping

#string projectResultsDir
#string projectJobsDir
#string project
#string intermediateDir
#string annotationGtf
#string seqType
#string ensembleReleaseVersion
#string groupname
#string tmpName

# Change permissions

umask 0007

# Make result directories
mkdir -p ${projectResultsDir}/alignment
mkdir -p ${projectResultsDir}/expression
mkdir -p ${projectResultsDir}/qc

# Copy project csv file to project results directory

cp ${projectJobsDir}/${project}.csv ${projectResultsDir}

	cp ${intermediateDir}/*.merged.exonTagged.bam ${projectResultsDir}/alignment

# copy GeneCounts to results directory

	cp ${intermediateDir}/*UMIs_counts_per_gene_exon.txt ${projectResultsDir}/expression/
	cp ${intermediateDir}/*total_readcounts_per_gene_exon_tagged.txt ${projectResultsDir}/expression/ 
	cp ${intermediateDir}/*DigitalExpression_cell_readcounts.txt ${projectResultsDir}/expression/ 

	cp ${annotationGtf} ${projectResultsDir}/expression/

# Copy QC images and report to results directory

	cp ${intermediateDir}/*polyA_trimming_report.txt ${projectResultsDir}/qc
	cp ${intermediateDir}/*unaligned_tagged_Cellular.bam_summary.txt ${projectResultsDir}/qc
	cp ${intermediateDir}/*unaligned_tagged_Molecular.bam_summary.txt ${projectResultsDir}/qc
	cp ${intermediateDir}/*adapter_trimming_report.txt ${projectResultsDir}/qc
	cp ${intermediateDir}/*hisat.log ${projectResultsDir}/qc


# write README.txt file

cat > ${projectResultsDir}/README.txt <<'endmsg'

Morris A. Swertz
University of Groningen, University Medical Center Groningen, Genomics Coordination Center, Groningen, the Netherlands
University of Groningen, University Medical Center Groningen, Department of Genetics, Groningen, the Netherlands

Description of the different steps used in the ScRNA analysis pipeline

RNA Isolation, Sample Preparation and sequencing
Initial quality check of and RNA quantification of the samples was performed by capillary 
electrophoresis using the LabChip GX (Perkin Elmer). Non-degraded RNA-samples were 
selected for subsequent sequencing analysis. 
Sequence libraries were generated using the TruSeq RNA sample preparation kits (Illumina) 
using the Sciclone NGS Liquid Handler (Perkin Elmer). In case of contamination of adapter-
duplexes an extra purification of the libraries was performed with the automated agarose 
gel separation system Labchip XT (PerkinElmer). The obtained cDNA fragment libraries were 
sequenced on an Illumina HiSeq2500 using default parameters (single read 1x50bp or Paired 
End 2 x 100 bp) in pools of multiple samples.

Gene expression quantification
The trimmed fastQ files where aligned to build ${indexFileID} ensembleRelease ${ensembleReleaseVersion} 
reference genome using ${hisatVersion} [1] with default settings. Before gene quantification 
${samtoolsVersion} [2] was used to sort the aligned reads. 
The gene level quantification was performed by HTSeq-count ${htseqVersion} [3] using --mode=union, 
Ensembl version ${ensembleReleaseVersion} was used as gene annotation database which is included
in folder expression/. 

Results archive
The zipped archive contains the following data and subfolders:

- alignment: merged BAM file with index, md5sums and alignment statistics (.Log.final.out)
- expression: textfiles with gene level quantification per sample and per project. 
- images: QC images
- rawdata: raw sequence file in the form of a gzipped fastq file (.fq.gz)

The root of the results directory contains the final QC report, README.txt and the samplesheet which 
form the basis for this analysis. 

Used toolversions:

${jdkVersion}
${picardVersion}
${ghostscriptVersion}
${hisatVersion}

1. Daehwan Kim, Ben Langmead & Steven L Salzberg: HISAT: a fast spliced aligner with low
memory requirements. Nature Methods 12, 357–360 (2015)
2. Li H, Handsaker B, Wysoker A, Fennell T, Ruan J, Homer N, Marth G, Abecasis G, Durbin R,
Subgroup 1000 Genome Project Data Processing: The Sequence Alignment/Map format and SAMtools.
Bioinforma 2009, 25 (16):2078–2079.
3. Anders S, Pyl PT, Huber W: HTSeq – A Python framework to work with high-throughput sequencing data
HTSeq – A Python framework to work with high-throughput sequencing data. 2014:0–5.
4. Andrews, S. (2010). FastQC a Quality Control Tool for High Throughput Sequence Data [Online]. 
Available online at: http://www.bioinformatics.babraham.ac.uk/projects/fastqc/ ${samtoolsVersion}
5. Picard Sourceforge Web site. http://picard.sourceforge.net/ ${picardVersion}
6. The Genome Analysis Toolkit: a MapReduce framework for analyzing next-generation DNA sequencing data. 
McKenna A et al.2010 GENOME RESEARCH 20:1297-303, Version: ${gatkVersion}

endmsg

# Create zip file for all "small text" files

cd ${projectResultsDir}

zip -g ${projectResultsDir}/${project}.zip ${project}.csv
zip -gr ${projectResultsDir}/${project}.zip expression
zip -gr ${projectResultsDir}/${project}.zip qc
zip -g ${projectResultsDir}/${project}.zip README.txt

# Create md5sum for zip file

cd ${projectResultsDir}
md5sum ${project}.zip > ${projectResultsDir}/${project}.zip.md5

# add u+rwx,g+r+w rights for GAF group

chmod -R u+rwX,g+rwX ${projectResultsDir}
chmod -R g+rwX ${intermediateDir}