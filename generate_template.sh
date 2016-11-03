#!/bin/bash

module load NGS_ScRNA/1.0.1-Molgenis-Compute-v16.08.1-Java-1.8.0_74
module list


HOST=$(hostname)
##Running script for checking the environment variables
sh ${EBROOTNGS_SCRNA}/checkEnvironment.sh ${HOST}

ENVIRONMENT=$(awk '{print $1}' ./environment_checks.txt)
TMPDIR=$(awk '{print $2}' ./environment_checks.txt)
GROUP=$(awk '{print $3}' ./environment_checks.txt)
ENVIRONMENT="calculon"

PROJECT="PROJECTNAME"
RUNID="run01"

WORKDIR="/groups/${GROUP}/${TMPDIR}"
SPECIES="homo_sapiens" # homo_sapiens, mus_musculus

WORKFLOW=${EBROOTNGS_SCRNA}/workflow.csv

if [ -f .compute.properties ];
then
     rm .compute.properties
fi

if [ -f ${GAF}/generatedscripts/${PROJECT}/out.csv  ];
then
	rm -rf ${GAF}/generatedscripts/${PROJECT}/out.csv
fi

perl ${EBROOTNGS_SCRNA}/convertParametersGitToMolgenis.pl ${EBROOTNGS_SCRNA}/parameters.csv > \
${WORKDIR}/generatedscripts/${PROJECT}/parameters.csv

perl ${EBROOTNGS_SCRNA}/convertParametersGitToMolgenis.pl ${EBROOTNGS_SCRNA}/parameters.${SPECIES}.csv > \
${WORKDIR}/generatedscripts/${PROJECT}/parameters.${SPECIES}.csv

perl ${EBROOTNGS_SCRNA}/convertParametersGitToMolgenis.pl ${EBROOTNGS_SCRNA}/parameters.${ENVIRONMENT}.csv > \
${WORKDIR}/generatedscripts/${PROJECT}/parameters.${ENVIRONMENT}.csv


sh ${EBROOTMOLGENISMINCOMPUTE}/molgenis_compute.sh \
-p ${WORKDIR}/generatedscripts/${PROJECT}/parameters.csv \
-p ${WORKDIR}/generatedscripts/${PROJECT}/parameters.${SPECIES}.csv \
-p ${WORKDIR}/generatedscripts/${PROJECT}/parameters.${ENVIRONMENT}.csv \
-p ${WORKDIR}/generatedscripts/${PROJECT}/${PROJECT}.csv \
-w ${EBROOTNGS_SCRNA}/create_in-house_ngs_projects_workflow.csv \
-rundir ${WORKDIR}/generatedscripts/${PROJECT}/scripts \
--runid ${RUNID} \
--weave \
--generate \
-o "workflowpath=${WORKFLOW};\
outputdir=scripts/jobs;groupname=${GROUP};\
mainParameters=${WORKDIR}/generatedscripts/${PROJECT}/parameters.csv;\
worksheet=${WORKDIR}/generatedscripts/${PROJECT}/${PROJECT}.csv;\
parameters_species=${WORKDIR}/generatedscripts/${PROJECT}/parameters.${SPECIES}.csv;\
parameters_environment=${WORKDIR}/generatedscripts/${PROJECT}/parameters.${ENVIRONMENT}.csv;\
ngsversion='NGS_ScRNA/1.0.1-Molgenis-Compute-v16.08.1-Java-1.8.0_74';"
