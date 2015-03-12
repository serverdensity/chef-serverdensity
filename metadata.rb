name               'serverdensity'
maintainer         'Server Density'
maintainer_email   'hello@serverdensity.com'
license            'MIT'
description        'Installs/configures Server Density sd-agent'
long_description   IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version            '2.1.2'

depends 'apt', '~> 2.6'
depends 'yum', '~> 3.3'
depends 'dpkg_autostart', '~> 0.1.6'

supports 'ubuntu'
supports 'debian'
supports 'centos'
supports 'redhat'
supports 'fedora'
supports 'amazon'
supports 'scientific'

recipe 'serverdensity::default', 'Installs serverdensity agent'
recipe 'serverdensity::alerts', 'Installs, configures and starts sd-agent and creates alerts'

## Basic Config

attribute "serverdensity/account",
  :display_name => "Your Server density account",
  :description => "Your Server Density subdomain, i.e. companyname.serverdensity.io",
  :type => "string",
  :required => "required"

attribute "serverdensity/agent_key",
  :display_name => "Your Server density agent key",
  :description => "Your Server Density agent key (don't set this if you want to use the API to handle querying nodes/creating nodes)",
  :type => "string"

attribute "serverdensity/enabled",
  :display_name => "Enablement of sd-agent",
  :description => "Should sd-agent be running, default true",
  :default => true

## Optional API Config

attribute "serverdensity/username",
  :display_name => "Username",
  :description => "Username for authenticating with the v1 API (if agent_key isn't set)",
  :type => "string"

attribute "serverdensity/password",
  :display_name => "Password",
  :description => "Password for authenticating with the v1 API (if agent_key isn't set)",
  :type => "string"

attribute "serverdensity/token",
  :display_name => "Api Token for V2 API",
  :description => "Your API token from Preferences > Security in Server Density.",
  :type => "string"

## Optional Advanced Config

attribute "serverdensity/sd_url",
  :display_name => "SD url",
  :description => "By default this will be 'https://\#{node.serverdensity.account}', avoid setting manually where possible.",
  :type => "string"

attribute "serverdensity/device_group",
  :display_name => "Device Group",
  :description => "Sets the group for the device to be created in, to inherit alerts automatically.",
  :type => "string"

attribute "serverdensity/apache_status_url",
  :display_name => "Apache Statuts Url",
  :description => "URL to get the Apache2 status page from (e.g. mod_status), disabled if not set",
  :type => "string"

attribute "serverdensity/apache_status_user",
  :display_name => "Apache Statuts User",
  :description => "Username to authenticate to the Apache2 status page, required if apache_status_url is set",
  :type => "string"

attribute "serverdensity/apache_status_pass",
  :display_name => "Apache Statuts Password",
  :description => "Password to authenticate to the Apache2 status page, required if apache_status_url is set",
  :type => "string"

attribute "serverdensity/mongodb_server",
  :display_name => "Server to get MongoDB status monitoring from",
  :description => "Server to get MongoDB status monitoring from, this takes a full MongoDB connection URI so you can set username/password etc. details here if needed, disabled if not set",
  :type => "string"

attribute "serverdensity/mongodb_dbstats",
  :display_name => "Enablement of MongoDB stats",
  :description => "Enables MongoDB stats if true and mongodb_server is set, default: false",
  :default => false

attribute "serverdensity/apache_status_pass",
  :display_name => "Enablement of MongoDB replset stats",
  :description => "Enables MongoDB replset stats if true and mongodb_server is set, default: false",
  :default => false

attribute "serverdensity/mysql_server",
  :display_name => "Server to get MySQL status monitoring from",
  :description => "Server to get MySQL status monitoring from, disabled if not set",
  :type => "string"

attribute "serverdensity/mysql_user",
  :display_name => "Mysql User",
  :description => "Username to authenticate to MySQL, required if mysql_server is set",
  :type => "string"

attribute "serverdensity/mysql_pass",
  :display_name => "Mysql Password",
  :description => "Password to authenticate to MySQL, required if mysql_server is set",
  :type => "string"

attribute "serverdensity/nginx_status_url",
  :display_name => "Nginx status url",
  :description => "URL to get th Nginx status page from, disabled if not set",
  :type => "string"

attribute "serverdensity/rabbitmq_status_url",
  :display_name => "Rabbitmq Status Url",
  :description => "URL to get the RabbitMQ status from via HTTP management API, disabled if not set",
  :type => "string"

attribute "serverdensity/rabbitmq_user",
  :display_name => "Rabbitmq User",
  :description => "Username to authenticate to the RabbitMQ management API, required if rabbitmq_status_url is set",
  :type => "string"

attribute "serverdensity/rabbitmq_pass",
  :display_name => "Rabbitmq Password",
  :description => "Password to authenticate to the RabbitMQ management API, required if rabbitmq_status_url is set",
  :type => "string"

attribute "serverdensity/tmp_directory",
  :display_name => "Tmp Directory",
  :description => "Override where the agent stores temporary files, system default tmp will be used if not set",
  :type => "string"

attribute "serverdensity/pidfile_directory",
  :display_name => "Pidfile Directory",
  :description => "Override where the agent stores it's PID file, temp dir (above or system default) is used if not set",
  :type => "string"

attribute "serverdensity/logging_level",
  :display_name => "Logging Level",
  :description => "Set the logging level for the agent",
  :type => "string"

attribute "serverdensity/alerts",
  :display_name => "Alerts",
  :description => "This should be an array of hashes, each of which defines an alert, keys should match those exposed by the alert LWRP and will be created by the alerts recipe.",
  :type => "array"

attribute "serverdensity/plugin_dir",
  :display_name => "Plugin Directory",
  :description => "Sets the directory the agent looks for plugins, if left blank it is ignored",
  :type => "array"
