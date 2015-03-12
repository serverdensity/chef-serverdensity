#
# Cookbook Name:: serverdensity
# Library:: matchers

if defined?(ChefSpec)
  def clear_serverdensity(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:serverdensity, :clear, resource_name)
  end

  def configure_serverdensity(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:serverdensity, :configure, resource_name)
  end

  def disable_serverdensity(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:serverdensity, :disable, resource_name)
  end

  def enable_serverdensity(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:serverdensity, :enable, resource_name)
  end

  def setup_serverdensity(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:serverdensity, :setup, resource_name)
  end

  def update_serverdensity(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:serverdensity, :update, resource_name)
  end

  def create_serverdensity_alert(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:serverdensity_alert, :create, resource_name)
  end

  def enable_serverdensity_plugin(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:serverdensity_plugin, :enable, resource_name)
  end

  def disable_serverdensity_plugin(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:serverdensity_plugin, :disable, resource_name)
  end

end
