#!/bin/bash

set -o pipefail -eu

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

# Detect # of CPUs so make jobs can be parallelized
CPUS=$(grep -c ^processor /proc/cpuinfo)

DEST_DIR="${DEST_DIR:-$(mktemp -d)}"
echo "Downloading into $DEST_DIR. To clean up: 'rm -rf $DEST_DIR'"

mkdir -p "${DEST_DIR}/workdir"
mkdir -p "${DEST_DIR}/datadog-agent"

(
  cd "${DEST_DIR}/datadog-agent"
  echo "Downloading curl"
  wget -nc https://curl.haxx.se/download/curl-7.62.0.tar.gz
  echo "Downloading libffi"
  wget -nc ftp://sourceware.org/pub/libffi/libffi-3.2.1.tar.gz
  echo "Downloading pkg-config"
  wget -nc https://pkgconfig.freedesktop.org/releases/pkg-config-0.29.2.tar.gz
)


echo "Downloading pip dependencies"

pip download --no-binary :all: --dest="$DEST_DIR/datadog-agent" 'wheel==0.32.2'
pip download --no-binary :all: --dest="$DEST_DIR/datadog-agent" 'virtualenv==16.1.0'
pip download --no-binary :all: --dest="$DEST_DIR/datadog-agent" 'urllib3[secure]==1.24.1'
pip download --no-binary :all: --dest="$DEST_DIR/datadog-agent" "pip==18.1"
pip download --no-binary :all: --dest="$DEST_DIR/datadog-agent" -r "${SCRIPT_DIR}/requirements.txt"
pip download --no-binary :all: --dest="$DEST_DIR/datadog-agent" -r "${SCRIPT_DIR}/requirements-opt.txt"

echo "Done, blobs are in ${DEST_DIR}/datadog-agent. To add them:"

for i in $(find "${DEST_DIR}/datadog-agent" -type f); do
  echo "bosh add-blob $i datadog-agent/${i##*/}"
done

echo "To clean up: 'rm -rf $DEST_DIR'"
