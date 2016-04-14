
#
# Cookbook Name:: serverdensity
# Resource:: default

actions :clear, :configure, :disable, :enable, :setup, :sync, :update
default_action :update

# account domain
attribute :account,
  :kind_of => String

# device name
attribute :name,
  :kind_of => String,
  :name_attribute => true,
  :required => true

# api token
attribute :token,
  :kind_of => String

# optional agent_key (nil forces refresh)
attribute :agent_key,
  :kind_of => [String, NilClass],
  :regex => /^\w{32}$/

# optional device identifier (defaults to device name)
attribute :device,
  :kind_of => [Hash, String]

# optional metadata
attribute :metadata,
  :kind_of => Hash,
  :default => {}

# optional settings
attribute :settings,
  :kind_of => Hash,
  :default => {}
