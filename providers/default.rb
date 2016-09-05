#
# Cookbook Name:: serverdensity
# Provider:: default

def whyrun_supported?
  true
end

# actions
use_inline_resources
action :clear do
  converge_by 'delete all existing Server Density alerts for device' do
    @new_resource.updated_by_last_action device.reset
  end if device
end

action :configure do
  converge_by 'fetch Server Density agent key' do
    node.normal.serverdensity.agent_key = agent_key
    raise 'Unable to acquire a ServerDensity agent_key' if agent_key.nil?
  end

  template.cookbook 'serverdensity'
  template.source 'agent.cfg.erb'

  template.mode 00644

  template.variables Chef::Mixin::DeepMerge.merge(
    node["serverdensity"].to_hash,
    @new_resource.settings
  )

  template.run_action :create

  link.to template.path
  link.run_action :create

  @new_resource.updated_by_last_action template.updated_by_last_action?
end

action :disable do
  service.run_action :stop if service.running
  service.run_action :disable if service.enabled
  @new_resource.updated_by_last_action service.updated_by_last_action?
end

action :enable do
  if service.running
    service.run_action :restart if @new_resource.updated_by_last_action?
  else
    service.run_action :enable unless service.enabled
    service.run_action :start
  end
  @new_resource.updated_by_last_action service.updated_by_last_action?
end

action :setup do
  api = case
    when token
      ServerDensity::API.configure 2.0, token
  end
  @new_resource.updated_by_last_action !api.nil?
end

action :sync do
  converge_by 'update metadata on Server Density' do
    if result = device.update(metadata)
      @new_resource.updated_by_last_action !result.empty?
      node.normal.serverdensity.metadata = result.merge(metadata)
    end
  end if sync_required? && device
end

action :update do
  if node["serverdensity"]["enabled"]
    action_setup
    action_configure
    action_enable
    action_sync if ServerDensity::API.configured?
  else
    action_disable
  end
end

# accessors

def account
  @account ||= @new_resource.account ||
    node["serverdensity"]["account"] ||
    node["serverdensity"]["sd_url"].sub(/^https?:\/\//, '')
rescue
  nil
end

def agent_key
  @agent_key ||= @new_resource.agent_key ||
    node["serverdensity"]["agent_key"] ||
    key_from_file ||
    key_from_ec2 ||
    key_from_api
end

def username
  @new_resource.username || node["serverdensity"]["username"]
end

def password
  @new_resource.password || node["serverdensity"]["password"]
end

def token
  @new_resource.token || node["serverdensity"]["token"]
end

# methods

def define_resource_requirements
  requirements.assert(:clear, :sync) do |a|
    a.assertion { ServerDensity::API.configured? }
    a.failure_message Exception, 'Server Density API has not been configured'
  end
end

def device
  return unless ServerDensity::API.configured?
  query = if @new_resource.device
    @new_resource.device
  elsif provider.empty?
    @new_resource.name
  else
    provider
  end
  @device ||= node.normal.serverdensity.metadata =
    ServerDensity::Device.find(query) ||
    ServerDensity::Device.create(metadata)
end

def key_from_api
  validate device.agent_key if device
end

def key_from_ec2
  if node.attribute?(:ec2)
    validate node["ec2"]["userdata"].split(':').last rescue nil
  end
end

def key_from_file
  validate ::File.read '/etc/sd-agent-key' if ::File::exist? '/etc/sd-agent-key'
end

def link
  @link ||= Chef::Resource::Link.new('/etc/sd-agent/config.cfg', run_context)
end

def metadata
  @metadata ||= {
    group: node["serverdensity"]["device_group"] || 'chef-autodeploy',
    hostname: node["hostname"],
    name: @new_resource.name
  }.merge(provider).merge(@new_resource.metadata)
end

def provider
  @provider ||= case
    when (node["ec2"]["instance_id"] rescue false)
      { provider: 'amazon', providerId: node["ec2"]["instance_id"] }
    when (node["opsworks"]["instance"]["aws_instance_id"] rescue false)
      { provider: 'amazon', providerId: node["opsworks"]["instance"]["aws_instance_id"] }
    else
      {}
  end
end

def service
  @service ||= begin
    resource = Chef::Resource::Service.new('sd-agent', run_context)
    provider = resource.provider_for_action(:enable)
    provider.load_current_resource
    provider.load_new_resource_state
    resource
  end
end

def sync_required?
  not metadata.reject do |k, v|
    node.normal.serverdensity.metadata[k] == v
  end .empty?
end

def template
  @template ||= Chef::Resource::Template.new(
    '/etc/sd-agent/conf.d/agent.cfg',
    run_context
  )
end

def validate(key)
  key.match(/^\w{32}$/) ? key : nil
end