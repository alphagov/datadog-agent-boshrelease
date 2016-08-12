# BOSH Release for datadog-agent

## Usage

To use this bosh release, first upload it to your bosh:

```
bosh target BOSH_HOST
git clone https://github.com/cloudfoundry-community/datadog-agent-boshrelease.git
cd datadog-agent-boshrelease
bosh upload release
```

### Development

As a developer of this release, create new releases and upload them:

```
bosh create release --force && bosh -n upload release
```
