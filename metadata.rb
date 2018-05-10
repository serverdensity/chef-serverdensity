name             'serverdensity'
maintainer       'hello@serverdensity.com'
maintainer_email 'hello@serverdensity.com'
license          'All rights reserved'
description      'Installs/Configures the v2 Server Density monitoring agent'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '3.1.1'
issues_url       'https://github.com/serverdensity/chef-serverdensity/issues'
source_url       'https://github.com/serverdensity/chef-serverdensity'

depends 'apt'
depends 'yum'
depends 'dpkg_autostart'

supports 'ubuntu'
supports 'debian'
supports 'centos'
supports 'redhat'
supports 'scientific'
supports 'oracle'

recipe 'serverdensity::default', 'Installs serverdensity agent'
