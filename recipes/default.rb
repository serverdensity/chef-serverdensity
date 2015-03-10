#
# Cookbook Name:: serverdensity
# Recipe:: default

return unless node.serverdensity.enabled

chef_gem 'rest-client'
require 'rest-client'

case node[:platform]

  when 'debian', 'ubuntu'
    include_recipe 'apt'

    apt_repository 'serverdensity' do
      key 'https://www.serverdensity.com/downloads/boxedice-public.key'
      uri 'https://www.serverdensity.com/downloads/linux/deb'
      distribution 'all'
      components ['main']
      action :add
    end

    dpkg_autostart 'sd-agent' do
      allow false
    end

  when 'redhat', 'centos', 'fedora', 'scientific', 'amazon'

    yum_repository 'serverdensity' do
      description 'Server Density sd-agent'
      baseurl 'https://www.serverdensity.com/downloads/linux/redhat/'
      gpgkey 'https://www.serverdensity.com/downloads/boxedice-public.key'
    end

end

package 'sd-agent'

file '/etc/sd-agent/config.cfg' do
  action :delete
  not_if { ::File.symlink?(path) }
end

service 'sd-agent' do
  supports [:start, :stop, :restart]
  action :nothing
end

directory '/etc/sd-agent/conf.d'
directory node.serverdensity.plugin_dir do
  recursive true
end
