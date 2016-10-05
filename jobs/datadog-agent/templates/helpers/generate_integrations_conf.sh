#!/bin/bash
set -e
set -u

INTEGRATION_DIR="/var/vcap/jobs/datadog-agent/config/datadog-integrations"

mkdir -p "${INTEGRATION_DIR}"
rm -f "${INTEGRATION_DIR}/*"

<% p("integrations").each do |integration, config| %>
mkdir -p "$INTEGRATION_DIR"
cat <<YAML > "$INTEGRATION_DIR/<%= integration %>.yaml"
<%= JSON.dump(config) %>
YAML
<% end %>
