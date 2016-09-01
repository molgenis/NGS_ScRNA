#!/bin/bash

module load NGS_ScRNA
module list


HOST=$(hostname)
##Running script for checking the environment variables
sh ${EBROOTNGS_ScRNA}/checkEnvironment.sh ${HOST}

ENVIRONMENT=$(awk '{print $1}' ./environment_checks.txt)
TMPDIR=$(awk '{print $2}' ./environment_checks.txt)
GROUP=$(awk '{print $3}' ./environment_checks.txt)
ENVIRONMENT="calculon"

PROJECT="PROJECTNAME"
RUNID="run01"

WORKDIR="/groups/${GROUP}/${TMPDIR}"
BUILD="b37" # b37, b38
SPECIES="homo_sapiens"

WORKFLOW=${EBROOTNGS_ScRNA}/workflow.csv

if [ -f .compute.properties ];
then
     rm .compute.properties
fi

if [ -f ${GAF}/generatedscripts/${PROJECT}/out.csv  ];
then
	rm -rf ${GAF}/generatedscripts/${PROJECT}/out.csv
fi

perl ${EBROOTNGS_ScRNA}/convertParametersGitToMolgenis.pl ${EBROOTNGS_ScRNA}/parameters.csv > \
${WORKDIR}/generatedscripts/${PROJECT}/parameters.csv

perl ${EBROOTNGS_ScRNA}/convertParametersGitToMolgenis.pl ${EBROOTNGS_ScRNA}/parameters.${SPECIES}.csv > \
${WORKDIR}/generatedscripts/${PROJECT}/parameters.${SPECIES}.csv

perl ${EBROOTNGS_ScRNA}/convertParametersGitToMolgenis.pl ${EBROOTNGS_ScRNA}/parameters.${ENVIRONMENT}.csv > \
${WORKDIR}/generatedscripts/${PROJECT}/parameters.${ENVIRONMENT}.csv


sh ${EBROOTMOLGENISMINCOMPUTE}/molgenis_compute.sh \
-p ${WORKDIR}/generatedscripts/${PROJECT}/parameters.csv \
-p ${WORKDIR}/generatedscripts/${PROJECT}/parameters.${SPECIES}.csv \
-p ${WORKDIR}/generatedscripts/${PROJECT}/parameters.${ENVIRONMENT}.csv \
-p ${WORKDIR}/generatedscripts/${PROJECT}/${PROJECT}.csv \
-w ${EBROOTNGS_ScRNA}/create_in-house_ngs_projects_workflow.csv \
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
ngsversion='1.0.0';"
