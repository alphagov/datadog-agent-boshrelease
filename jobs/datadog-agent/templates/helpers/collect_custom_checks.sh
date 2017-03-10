#!/bin/bash -eu

JOBS_PATH=/var/vcap/jobs
DD_AGENT_HOME=/var/vcap/packages/datadog-agent/agent

check_files=$(find -L "${JOBS_PATH}" -maxdepth 4 -mindepth 4 -type f -a -path '*/config/datadog-integrations/*\.py' -printf '%f\n' | sort)
duplicates=$(echo "${check_files}" | uniq -cd)

if [ ! -z "${duplicates}" ] ; then 
  echo "Multiple checks with same name found: ${duplicates}. Failing custom check collection."
  exit 1
elif [ ! -z "${check_files}" ] ; then
  cp $(find -L "${JOBS_PATH}" -maxdepth 4 -mindepth 4 -type f -a -path '*/config/datadog-integrations/*\.py') "${DD_AGENT_HOME}"/checks.d
fi

