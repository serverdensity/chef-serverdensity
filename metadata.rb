name               'serverdensity'
maintainer         'Server Density'
maintainer_email   'hello@serverdensity.com'
license            'MIT'
description        'Installs/configures Server Density sd-agent'
long_description   IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version            '2.1.1'

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
