# BOSH Release for datadog-agent

This release only supports Ubuntu Trusty stemcells - it uses the python-dev apt package.
Packaging requires Internet connectivity - Python packages are downloaded to the install target.

## Usage

To use this bosh release, first upload it to your bosh:

```
bosh target BOSH_HOST
git clone https://github.com/onemedical/datadog-agent-boshrelease.git
cd datadog-agent-boshrelease
bosh upload release
```

Configure the agent on each of your instance groups:

```
instance_groups:
- name: myservice
  jobs:
  - name: datadog-agent
    release: datadog-agent
    properties:
      api_key: abc123...
      tags:
        service: myservice
```

### Collecting AWS tags

To collect AWS tags, set up a Datadog role following the [Datadog instructions](http://docs.datadoghq.com/integrations/aws/).
Instead of creating a "Role for Cross-Account Access," create an "Amazon EC2" role.
Use that role name in your cloud config and enable EC2 tag collection on the instance group:

```
vm_extensions:
- name: datadog
  cloud_properties:
    iam_instance_profile: datadog-instance-profile
```

```
instance_groups:
- name: myservice
  vm_extensions: [datadog]
  jobs:
  - name: datadog-agent
    release: datadog-agent
    properties:
      api_key: abc123...
      collect_ec2_tags: true
      tags:
        service: myservice
```

### Agent integrations

Some [Datadog integrations are configured in the agent](https://github.com/DataDog/dd-agent/tree/5.8.5/conf.d).
This release has support to configure them.

Note: These integrations depend on ["optional" dependencies in the agent](https://github.com/DataDog/dd-agent/blob/5.8.5/requirements-opt.txt).
The `datadog-agent` package installs these but some fail due to missing dependencies. Currently these packages are not working:

  * `pgbouncer` depends on `libpq`, which this release does not include

#### Configuring integrations adhoc in the manifest

The end user can configure integrations by embedding the YAML in the properties:

```
instance_groups:
- name: myservice
  jobs:
  - name: datadog-agent
    release: datadog-agent
    properties:
      integrations:
        process:
          init_config:
            pid_cache_duration: 30
          instances:
          - name: myservice
            search_string: ["myservice"]
            thresholds:
              critical: [1, 9]
```

#### Configuring integrations from 3rd party releases

Third party releases might want to extend datadog agent to monitor local services using these additional checks.

This release has logic to merge all files from jobs which follow this pattern:

  ${JOB_PATH}/config/datadog-integrations/${checkname}.yaml

For example:

  /var/vcap/jobs/datadog-router/config/datadog-integrations/process.yaml

The script will use [spruce](https://github.com/geofffranks/spruce) to merge all the configurations in one unique file per check, as datadog agent expects. Merging the config with spruces allows multiple jobs add configuration for some checks, for instance to monitor different processes. Additionally the release developer can use [the spruce syntax](https://github.com/geofffranks/spruce) if the need to, although default merge strategy is good enough.

## Development

As a developer of this release, create new releases and upload them:

```
bosh create release --force && bosh -n upload release
```
