#!/bin/bash

set -e
set -u

SPRUCE=/var/vcap/packages/spruce/bin/spruce
JOBS_PATH=/var/vcap/jobs
DD_AGENT_HOME=/var/vcap/packages/datadog-agent/agent

rm -f "${DD_AGENT_HOME}"/conf.d/*.yaml

check_file_names=$(find -L "${JOBS_PATH}" -maxdepth 4 -mindepth 4 -type f -a -path '*/config/datadog-integrations/*yaml' -printf '%f\n' | sort -u)

for f in ${check_file_names}; do
  files_to_merge=$(find -L "${JOBS_PATH}" -maxdepth 4 -mindepth 4 -type f -a -path "*/config/datadog-integrations/${f}")
  "${SPRUCE}" merge ${files_to_merge} > "${DD_AGENT_HOME}"/conf.d/"${f}"
done
