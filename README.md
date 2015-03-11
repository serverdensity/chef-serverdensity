# chef-serverdensity

This cookbook provides an easy way to install the [Server Density agent](https://github.com/serverdensity/sd-agent/) and manage server specific alerts.

### Table of Contents
  - [Requirements](#requirements)
  - [Basic Usage](#usage)
  - [Attributes](#attributes)
  - [Provided Recipes](#recipes)
  - [Provided Resources (LWRPs)](#lwrp)
  - [Notes](#notes)

## Requirements

### Cookbooks

This cookbook has dependencies on the following cookbooks:

 * [apt](https://github.com/opscode-cookbooks/apt)
 * [yum::epel](https://github.com/opscode-cookbooks/yum)

### Platforms:

 * Ubuntu
 * Debian
 * RHEL
 * CentOS
 * Fedora

## Usage

### Basic

  1. Include `recipe[serverdensity::alerts]` in a run list

  2. Then:
    * Override the `node['serverdensity']['agent_key']` attribute on a [higher level](http://wiki.opscode.com/display/chef/Attributes#Attributes-AttributesPrecedence). *recommended*
    * **or** use the API to query for devices matching the node's hostname or create a new one if not found, by setting the [config options](#optional-api-config).

### Advanced (recommended)

  1. Add `serverdensity` as a dependency to another cookbook

  2. Use `include_recipe 'serverdensity'` to install `sd-agent`

  3. Call the LWRP (Lightweight Resource Provider) as described [below](#lwrp) to dynamically configure `sd-agent`

  4. Call the `serverdensity_plugin` [LWRP](#serverdensity_plugin) to configure plugins

  5. Call the `serverdensity_alert` [LWRP](#serverdensity_alert) to configure custom alerts

## Attributes

### Basic Config

 * `node['serverdensity']['account']` **required**  
   Your Server Density subdomain, i.e. `companyname.serverdensity.io`
 * `node['serverdensity']['agent_key']`  
   Your Server Density agent key (don't set this if you want to use the API to handle querying nodes/creating nodes)
 * `node['serverdensity']['enabled']`  
   Should `sd-agent` be running, *default* `true`

### Optional API Config

If you don't set `agent_key` then set these parameters and new servers will be automatically created in your account.

*If your account URL ends in .com you are using v1*

 * `node['serverdensity']['username']`  
   Username for authenticating with the v1 API (if `agent_key` isn't set)
 * `node['serverdensity']['password']`  
   Password for authenticating with the v1 API (if `agent_key` isn't set)

*If your account URL ends in .io you are using v2*

 * `node['serverdensity']['token']`  
    Your API token from Preferences > Security in Server Density.

### Optional Advanced Config

 * `node['serverdensity']['sd_url']`  
   By default this will be "https://#{node.serverdensity.account}", avoid setting manually where possible.

 * `node['serverdensity']['device_group']`  
    Sets the group for the device to be created in, to inherit alerts automatically.

 * `node['serverdensity']['apache_status_url']`  
    URL to get the Apache2 status page from (e.g. `mod_status`), disabled if not set
 * `node['serverdensity']['apache_status_user']`  
    Username to authenticate to the Apache2 status page, required if `apache_status_url` is set
 * `node['serverdensity']['apache_status_pass']`  
    Password to authenticate to the Apache2 status page, required if `apache_status_url` is set

 * `node['serverdensity']['mongodb_server']`  
    Server to get MongoDB status monitoring from, this takes a full [MongoDB connection URI](http://docs.mongodb.org/manual/reference/connection-string/) so you can set username/password etc. details here if needed, disabled if not set
 * `node['serverdensity']['mongodb_dbstats']`  
    Enables MongoDB stats if `true` and `mongodb_server` is set, *default*: `false`
 * `node['serverdensity']['mongodb_replset']`  
    Enables MongoDB replset stats if `true` and `mongodb_server` is set, *default*: `false`

 * `node['serverdensity']['mysql_server']`  
    Server to get MySQL status monitoring from, disabled if not set
 * `node['serverdensity']['mysql_user']`  
    Username to authenticate to MySQL, required if `mysql_server` is set
 * `node['serverdensity']['mysql_pass']`  
    Password to authenticate to MySQL, required if `mysql_server` is set

 * `node['serverdensity']['nginx_status_url']`  
    URL to get th Nginx status page from, disabled if not set

 * `node['serverdensity']['rabbitmq_status_url']`  
    URL to get the RabbitMQ status from via [HTTP management API](http://www.rabbitmq.com/management.html), disabled if not set
 * `node['serverdensity']['rabbitmq_user']`  
    Username to authenticate to the RabbitMQ management API, required if `rabbitmq_status_url` is set
 * `node['serverdensity']['rabbitmq_pass']`  
    Password to authenticate to the RabbitMQ management API, required if `rabbitmq_status_url` is set

 * `node['serverdensity']['tmp_directory']`  
    Override where the agent stores temporary files, system default tmp will be used if not set
 * `node['serverdensity']['pidfile_directory']`  
    Override where the agent stores it's PID file, temp dir (above or system default) is used if not set

 * `node['serverdensity']['logging_level']`  
    Set the logging level for the agent

 * `node['serverdensity']['alerts']`  
    This should be an array of hashes, each of which defines an alert, keys should match those exposed by the [alert LWRP](#serverdensity_alert) and will be created by the alerts recipe.

 * `node['serverdensity']['plugin_dir']`  
    Sets the directory the agent looks for plugins, if left blank it is ignored
 * `node['serverdensity']['plugin_options']` **deprecated**  
    _Use the [plugin LWRP](#serverdensity_plugin) where possible, this exists for legacy reasons only._  
    A hash of optional named plugin options if you have agent plugins you want to configure, simple key-values will be added to the `[Main]` section of the config while sub-hashes will be generated into sections e.g. `{'Beanstalk'=>{'host'=>'localhost'}}` becomes:

```ini
[Beanstalk]
host = localhost
```

## Recipes

### default

Installs the sd-agent, ready for the LWRP based setup.

### alerts

Configures sd-agent from attributes rather than LWRPs, and creates attribute based alerts defined in the `['serverdensity']['alerts']` hash. Here is an example of an alert (for API v1):

```rb
node['serverdensity']['alerts']['high-load'] = { 
  'metadata' => {
    :userId => ['group'],
    :notificationType => ['email'],
    :checkType => 'loadAvrg',
    :comparison => :>,
    :triggerThreshold => 3,
    :notificationFixed => true,
    :notificationDelay => 5,
    :notificationFrequencyOnce => true
  }
}
```

## LWRP
An LWRP is a "Lightweight Resource Provider", or in plain english, an additional resource type you can use in your recipes.  This cookbook provides three such resources:

- `serverdensity`: the default resource for setting up the agent and registering devices, etc.
- `serverdensity_alert`: resource for setting up new alerts
- `serverdensity_plugin`: resource for installing and configuring plugins

### serverdensity

#### Actions

  - `clear`  
    remove all alerts from device
  - `configure`  
    write agent config, get token (see below)
  - `disable`  
    stop agent if running
  - `enable`  
    start agent if not running
  - `setup`  
    initialize API for future calls
  - `sync`  
    synchronize device metadata
  - `update` **(default)**  
    setup api, either configure and enable or disable agent, sync metadata if API is available

#### Getting a Device's Agent-Key

The `configure` action of this LWRP facilitates the dynamic configuration of the `sd-agent`. The `agent_key` for the device (which determines what device the agent connects to or whether it creates a new device) can be acquired by various methods. In this order, attempts are made to:

  1. Use the `agent_key` passed into LWRP
  2. Use `agent_key` defined in attributes (`node['serverdensity']['agent_key']`)
  3. Read the `agent_key` from `/etc/sd-agent-key` on the server
  4. Extract `agent_key` from EC2's internal metadata API (the last element of colon-separated user-data)
  5. Find the device in Server Density and request the `agent_key`
     - Based on the `device` passed to the LWRP; or (if `device` is not provided)
     - Based on provider data (AWS/Opsworks instance-id); or (if there is no provider)
     - Based on the name passed into the LWRP (the resource name)
  6. Create the device in Server Density and request the `agent_key`

Which of these steps take place depends on the various parameters passed in (see below), and when the `agent_key` is found. As soon as it is acquired no further steps are run.

##### Default

The default recipe (without API credentials provided) will use steps **2-4** to find an `agent_key`.

Below are examples of how to use the other steps.

##### Providing an agent_key (step 1)

```rb
serverdensity node.name do
  agent_key '00000000000000000000000000000000'
end
```

##### Finding/creating a device using the API (steps 5 & 6)

If you provide API credentials, this allows steps 5 & 6 to run.  That can be done either by setting the credentials in your attributes (as described under [Basic Config](#basic-config)), or by providing the credentials directly to the LWRP:

API V1:
```rb
# steps 2-6
serverdensity node.name do
  username 'foo'
  password 'bar'
end
```

API V2:
```rb
# steps 2-6
serverdensity node.name do
  token '00000000000000000000000000000000'
end
```

##### Device Property

Step **5** will use the criteria listed above in order of precedence to search for a matching device before proceeding to step 6 to create a new device.  As noted, the first criteria it checks for is the `device` property passed into the LWRP.

This property can be either a string, or a hash.  In the case of a string, it will search for a device with the given name.  In the case of a hash, it can be any field you want to search by (see API documentation for available fields: https://apidocs.serverdensity.com/#searching-for-a-device):

String
```rb
serverdensity node.name do
  token '00000000000000000000000000000000'
  device 'app_server_1'
end
```

Hash:
```rb
# v2 only (v1 only supports name and hostname keys)
serverdensity node.name do
  token '00000000000000000000000000000000'
  device :providerId => node.ec2.instance_id
end
```
(This is a silly example, of course, as EC2 instances would already use the same criteria by default)

#### Other settings

##### Metadata

The LWRP also supports writing metadata (via the sync action) to devices during creation via the API. Updating metadata is also supported when using API v2.

```rb
serverdensity node.name do
  token '00000000000000000000000000000000'
  metadata :group => 'chef-lwrp'
end
```

##### Settings

Settings is a hash used to override configuration options set in the attributes before the agent config file is written. Take a look at [this template](/templates/default/agent.cfg.erb) to see which settings can be defined.

### serverdensity\_alert

This is used to create alerts for your newly minted device, it currently just acts as a wrapper for API calls and as such, v1 and v2 usage is significantly different, the hope is to give them a shared DSL in the future.

**This LWRP requires that API credentials (v1 or v2) have been provided, if they have not, it will throw an error.**

#### API v1

```rb
# create v1 alert (https://github.com/serverdensity/sd-api-docs/blob/master/sections/alerts.md#add)
serverdensity_alert 'high-cpu' do
  metadata(
    :userId => ['group'],
    :notificationType => ['email'],
    :checkType => 'loadAvrg',
    :comparison => :>,
    :triggerThreshold => 3,
    :notificationFixed => true,
    :notificationDelay => 5,
    :notificationFrequencyOnce => true
  )
end
```

#### API v2

```rb
# create v2 alert
serverdensity_alert 'high-cpu' do
  metadata(
    # params as described here https://apidocs.serverdensity.com/Alerts/Alert_Configs/Creating
  )
end
```

### serverdensity\_plugin

This is used to install and configure plugins, it creates a new plugin config file inside `/etc/sd-agent/conf.d` and symlinks the file specified in `path` to the `plugin_dir`. Currently plugins must be placed on the server outside of this LWRP and then referenced (with `path`). A future goal is to allow plugin installation directly via 
[plugins.serverdensity.com](https://plugins.serverdensity.com/).

#### API (both versions)

```rb
# install Supervisord plugin, configure it, and restart the sd-agent
serverdensity_plugin 'Supervisord' do
  path '/opt/my-company/sd-plugins/Supervisord.py'
  config(
    rpc_url: 'unix:///var/run/supervisor.sock'
  )
  notifies :restart, 'service[sd-agent]'
end
```

The config file will namespace configurations so that they do not clash between plugins. The example above would produce the following config file:

```ini
[Supervisord]
rpc_url = unix:///var/run/supervisor.sock
```

**IMPORTANT**: Some older plugins may require global settings, if this is the case it is possible to use the `plugin_options` attribute to set these, however it is recommended to upgrade the plugin where possible.

## Notes

As this cookbook depends on a few [other cookbooks](#cookbooks) it's recommended you use a library like [Berkshelf](http://berkshelf.com/), [librarian-chef](https://github.com/applicationsonline/librarian-chef) or [knife-github-cookbooks](https://github.com/websterclay/knife-github-cookbooks) to automatically manage and install them.

## Publishing on the Chef Supermarket

https://supermarket.getchef.com/cookbooks/serverdensity

1. Clone the repo to `~/Desktop/serverdensity`
2. From CWD `~/Desktop` run `knife cookbook site share serverdensity "Monitoring & Trending" --cookbook-path ~/Desktop`

## References

  * [Server Density home page](http://www.serverdensity.com/)
  * [akatz/chef-serverdensity](https://github.com/akatz/chef-serverdensity)
  * [Jonty/chef-serverdensity](https://github.com/Jonty/chef-serverdensity)
  * [serverdensity/chef-serverdensity](https://github.com/serverdensity/chef-serverdensity)

## Authors

  * Original Author: Avrohom Katz <iambpentameter@gmail.com>
  * Modified by: Jonty Wareing <jonty@jonty.co.uk>
  * Modified by: Server Density <hello@serverdensity.com>
  * Rewritten by: Mal Graty <mal.graty@googlemail.com>
  * Other Contributors:
    * [Joe Marty](https://github.com/mltsy)

## License

[MIT](/LICENSE)
