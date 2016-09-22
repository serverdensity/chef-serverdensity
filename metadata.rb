name             'serverdensity'
maintainer       'hello@serverdensity.com'
maintainer_email 'hello@serverdensity.com'
license          'All rights reserved'
description      'Installs/Configures the v2 Server Density monitoring agent'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '3.0.3'
issues_url       'https://github.com/serverdensity/chef-serverdensity/issues'
source_url       'https://github.com/serverdensity/chef-serverdensity'

depends 'apt'
depends 'yum'
depends 'dpkg_autostart'

supports 'ubuntu'
supports 'debian'
supports 'centos'
supports 'redhat'

recipe 'serverdensity::default', 'Installs serverdensity agent'


## Basic Config

attribute "serverdensity/account",
  :display_name => "Your Server density account",
  :description => "Your Server Density subdomain, i.e. companyname.serverdensity.io",
  :type => "string",
  :required => "required"

attribute "serverdensity/agent_key",
  :display_name => "Your Server density agent key",
  :description => "Your Server Density agent key",
  :type => "string"

attribute "serverdensity/enabled",
  :display_name => "Enablement of sd-agent",
  :description => "Should sd-agent be running, default true",
  :default => true
