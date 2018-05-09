#
# Cookbook Name:: serverdensity
# Recipe:: default
#
# Copyright 2016, Server Density
#
# All rights reserved - Do Not Redistribute
#

return unless node["serverdensity"]["enabled"]

chef_gem 'rest-client' do
    version '~> 1.7.3'
    action :install
    compile_time false if Chef::Resource::ChefGem.method_defined?(:compile_time)
end

case node["platform"]

  when 'debian', 'ubuntu'
    include_recipe 'apt'

    case node['lsb']['codename'].downcase
      when 'artful', 'yakkety', 'xenial', 'zesty'
        node.run_state['repo_dist'] = 'xenial'
      when 'trusty', 'utopic', 'vivid', 'wily'
        node.run_state['repo_dist'] = 'trusty'
      when 'precise', 'quantal', 'raring', 'saucy'
        node.run_state['repo_dist'] = 'all'
      when 'wheezy', 'jessie', 'stretch'
        node.run_state['repo_dist'] = node['lsb']['codename'].downcase
      else
        node.run_state['repo_dist'] = 'all'
    end

    apt_repository 'serverdensity' do
      key 'https://archive.serverdensity.com/sd-packaging-public.key'
      uri "https://archive.serverdensity.com/#{node['platform']}/"
      distribution node.run_state['repo_dist']
      components ['main']
      action :add
    end

    dpkg_autostart 'sd-agent' do
      allow false
    end

  when 'centos', 'redhat', 'scientific', 'oracle'
    major = node['platform_version'].to_i
    if major == 6
      remote_file "#{Chef::Config[:file_cache_path]}/epel-release-latest.noarch.rpm" do
        source "https://dl.fedoraproject.org/pub/epel/epel-release-latest-6.noarch.rpm"
        notifies :install, "rpm_package[epel-release]", :immediately
        retries 5 # We may be redirected to a FTP URL, CHEF-1031.
      end

      rpm_package "epel-release" do
        source "#{Chef::Config[:file_cache_path]}/epel-release-latest.noarch.rpm"
        only_if {::File.exists?("#{Chef::Config[:file_cache_path]}/epel-release-latest.noarch.rpm")}
        action :nothing
      end

      if node["platform"] == "centos"
        ius_package = node["platform"]
      else
        ius_package = "rhel"
      end

      remote_file "#{Chef::Config[:file_cache_path]}/ius-release.rpm" do
        source "https://#{ius_package}6.iuscommunity.org/ius-release.rpm"
        notifies :install, "rpm_package[ius-release]", :immediately
        retries 5 # We may be redirected to a FTP URL, CHEF-1031.
      end

      rpm_package "ius-release" do
        source "#{Chef::Config[:file_cache_path]}/ius-release.rpm"
        only_if {::File.exists?("#{Chef::Config[:file_cache_path]}/ius-release.rpm")}
        action :nothing
      end
    end

    yum_repository 'serverdensity' do
      description 'Server Density sd-agent'
      baseurl 'https://archive.serverdensity.com/el/$releasever'
      gpgkey 'https://archive.serverdensity.com/sd-packaging-public.key'
    end

  when 'amazon'

    yum_repository 'serverdensity' do
      description 'Server Density sd-agent'
      baseurl 'https://archive.serverdensity.com/el/6'
      gpgkey 'https://archive.serverdensity.com/sd-packaging-public.key'
    end
end

package 'sd-agent'

service 'sd-agent' do
  supports [:start, :stop, :restart]
  action :nothing
end

serverdensity node.name do
    token node['serverdensity']['token']
end

if node['serverdensity']['apache_status_url']
    package 'sd-agent-apache'
    template '/etc/sd-agent/conf.d/apache.yaml' do
        source 'apache.yaml.erb'
        owner 'sd-agent'
        group 'sd-agent'
        mode 0644
        variables(
                  :apache_url => node['serverdensity']['apache_status_url'],
                  :apache_user => node['serverdensity']['apache_status_user'],
                  :apache_pass => node['serverdensity']['apache_status_pass'],
                  :apache_collection_interval => node['serverdensity']['apache_collection_interval']
                  )
        notifies :restart, 'service[sd-agent]', :delayed
    end
end

if node['serverdensity']['btrfs_excludes']
    package 'sd-agent-btrfs'
    template '/etc/sd-agent/conf.d/btrfs.yaml' do
        source 'btrfs.yaml.erb'
        owner 'sd-agent'
        group 'sd-agent'
        mode 0644
        variables(
                  :btrfs_excludes => node['serverdensity']['btrfs_excludes'],
                  )
        notifies :restart, 'service[sd-agent]', :delayed
    end
end

if node['serverdensity']['consul_url']
    package 'sd-agent-consul'
    template '/etc/sd-agent/conf.d/consul.yaml' do
        source 'consul.yaml.erb'
        owner 'sd-agent'
        group 'sd-agent'
        mode 0644
        variables(
                  :consul_url => node['serverdensity']['consul_url'],
                  :consul_checks => node['serverdensity']['consul_checks'],
                  :consul_whitelist => node['serverdensity']['consul_whitelist'],
                  :consul_collection_interval => node['serverdensity']['consul_collection_interval'],
                  )
        notifies :restart, 'service[sd-agent]', :delayed
    end
end

if node['serverdensity']['couchbase_server']
    package 'sd-agent-couchbase'
    template '/etc/sd-agent/conf.d/couchbase.yaml' do
        source 'couchbase.yaml.erb'
        owner 'sd-agent'
        group 'sd-agent'
        mode 0644
        variables(
                  :couchbase_server => node['serverdensity']['couchbase_server'],
                  :couchbase_user => node['serverdensity']['couchbase_user'],
                  :couchbase_password => node['serverdensity']['couchbase_password'],
                  :couchbase_timeout => node['serverdensity']['couchbase_timeout'],
                  :couchbase_collection_interval => node['serverdensity']['couchbase_collection_interval'],
                  )
        notifies :restart, 'service[sd-agent]', :delayed
    end
end

if node['serverdensity']['couchdb_server']
    package 'sd-agent-couchdb'
    template '/etc/sd-agent/conf.d/couch.yaml' do
        source 'couch.yaml.erb'
        owner 'sd-agent'
        group 'sd-agent'
        mode 0644
        variables(
                  :couchdb_server => node['serverdensity']['couchdb_server'],
                  :couchdb_user => node['serverdensity']['couchdb_user'],
                  :couchdb_password => node['serverdensity']['couchdb_password'],
                  :couchdb_timeout => node['serverdensity']['couchdb_timeout'],
                  :couchdb_whitelist => node['serverdensity']['couchdb_whitelist'],
                  :couchdb_blacklist => node['serverdensity']['couchdb_blacklist'],
                  :couchdb_collection_interval => node['serverdensity']['couchdb_collection_interval'],
                  )
        notifies :restart, 'service[sd-agent]', :delayed
    end
end

if !node['serverdensity']['directory'].empty?
    package 'sd-agent-directory'
    template '/etc/sd-agent/conf.d/directory.yaml' do
        source 'directory.yaml.erb'
        owner 'sd-agent'
        group 'sd-agent'
        mode 0644
        variables(
                  :directory => node['serverdensity']['directory'],
                  )
        notifies :restart, 'service[sd-agent]', :delayed
    end
end

if node['serverdensity']['docker_root']
    package 'sd-agent-docker'
    template '/etc/sd-agent/conf.d/docker.yaml' do
        source 'docker.yaml.erb'
        owner 'sd-agent'
        group 'sd-agent'
        mode 0644
        variables(
                  :docker_root => node['serverdensity']['docker_root'],
                  :docker_url => node['serverdensity']['docker_url'],
                  :docker_collection_interval => node['serverdensity']['docker_collection_interval'],
                  )
        notifies :restart, 'service[sd-agent]', :delayed
    end
end

if node['serverdensity']['elastic_url']
    package 'sd-agent-elastic'
    template '/etc/sd-agent/conf.d/elastic.yaml' do
        source 'elastic.yaml.erb'
        owner 'sd-agent'
        group 'sd-agent'
        mode 0644
        variables(
                  :elastic_url => node['serverdensity']['elastic_url'],
                  :elastic_username => node['serverdensity']['elastic_username'],
                  :elastic_password => node['serverdensity']['elastic_password'],
                  :elastic_cluster_stats => node['serverdensity']['elastic_cluster_stats'],
                  :elastic_pshard_stats => node['serverdensity']['elastic_pshard_stats'],
                  :elastic_pending_task_stats => node['serverdensity']['elastic_pending_task_stats'],
                  :elastic_ssl_verify => node['serverdensity']['elastic_ssl_verify'],
                  :elastic_ssl_cert => node['serverdensity']['elastic_ssl_cert'],
                  :elastic_ssl_key => node['serverdensity']['elastic_ssl_key'],
                  :elastic_timeout => node['serverdensity']['elastic_timeout'],
                  :elastic_collection_interval => node['serverdensity']['elastic_collection_interval'],
                  )
        notifies :restart, 'service[sd-agent]', :delayed
    end
end


if node['serverdensity']['haproxy_url']
    package 'sd-agent-haproxy'
    template '/etc/sd-agent/conf.d/haproxy.yaml' do
        source 'haproxy.yaml.erb'
        owner 'sd-agent'
        group 'sd-agent'
        mode 0644
        variables(
                  :haproxy_url => node['serverdensity']['haproxy_url'],
                  :haproxy_username => node['serverdensity']['haproxy_username'],
                  :haproxy_password => node['serverdensity']['haproxy_password'],
                  :haproxy_collection_interval => node['serverdensity']['haproxy_collection_interval'],
                  )
        notifies :restart, 'service[sd-agent]', :delayed
    end
end

if node['serverdensity']['hdfs_datanode_jmx_uri']
    package 'sd-agent-hdfs'
    template '/etc/sd-agent/conf.d/hdfs_datanode.yaml' do
        source 'hdfs_datanode.yaml.erb'
        owner 'sd-agent'
        group 'sd-agent'
        mode 0644
        variables(
                  :hdfs_datanode_jmx_uri => node['serverdensity']['hdfs_datanode_jmx_uri'],
                  :hdfs_collection_interval => node['serverdensity']['hdfs_collection_interval'],
                  )
        notifies :restart, 'service[sd-agent]', :delayed
    end
end

if node['serverdensity']['hdfs_namenode_jmx_uri']
    package 'sd-agent-hdfs'
    template '/etc/sd-agent/conf.d/hdfs_namenode.yaml' do
        source 'hdfs_namenode.yaml.erb'
        owner 'sd-agent'
        group 'sd-agent'
        mode 0644
        variables(
                  :hdfs_namenode_jmx_uri => node['serverdensity']['hdfs_namenode_jmx_uri'],
                  :hdfs_collection_interval => node['serverdensity']['hdfs_collection_interval'],
                  )
        notifies :restart, 'service[sd-agent]', :delayed
    end
end

if node['serverdensity']['kafka_c_connect_str']
    package 'sd-agent-kafka-consumer'
    template '/etc/sd-agent/conf.d/kafka_consumer.yaml' do
        source 'kafka_consumer.yaml.erb'
        owner 'sd-agent'
        group 'sd-agent'
        mode 0644
        variables(
                  :kafka_c_connect_str => node['serverdensity']['kafka_c_connect_str'],
                  :kafka_c_zk_connect_str => node['serverdensity']['kafka_c_zk_connect_str'],
                  :kafka_c_zk_timeout => node['serverdensity']['kafka_c_zk_timeout'],
                  :kafka_c_kafka_timeout => node['serverdensity']['kafka_c_kafka_timeout'],
                  :kafka_c_zk_connect_prefix => node['serverdensity']['kafka_c_zk_connect_prefix'],
                  :kafka_c_my_consumer => node['serverdensity']['kafka_c_my_consumer'],
                  :kafka_c_my_topic => node['serverdensity']['kafka_c_my_topic'],
                  :kafka_collection_interval => node['serverdensity']['kafka_collection_interval'],
                  )
        notifies :restart, 'service[sd-agent]', :delayed
    end
end

if node['serverdensity']['memcache_url']
    package 'sd-agent-memcache'
    template '/etc/sd-agent/conf.d/mcache.yaml' do
        source 'mcache.yaml.erb'
        owner 'sd-agent'
        group 'sd-agent'
        mode 0644
        variables(
                  :memcache_url => node['serverdensity']['memcache_url'],
                  :memcache_collection_interval => node['serverdensity']['memcache_collection_interval'],
                  )
        notifies :restart, 'service[sd-agent]', :delayed
    end
end

if node['serverdensity']['mongo_url']
    package 'sd-agent-mongo'
    template '/etc/sd-agent/conf.d/mongo.yaml' do
        source 'mongo.yaml.erb'
        owner 'sd-agent'
        group 'sd-agent'
        mode 0644
        variables(
                  :mongo_url => node['serverdensity']['mongo_url'],
                  :mongo_timeout => node['serverdensity']['mongo_timeout'],
                  :mongo_ssl => node['serverdensity']['mongo_ssl'],
                  :mongo_ssl_keyfile => node['serverdensity']['mongo_ssl_keyfile'],
                  :mongo_ssl_cert => node['serverdensity']['mongo_ssl_cert'],
                  :mongo_ssl_cert_reqs => node['serverdensity']['mongo_ssl_cert_reqs'],
                  :mongo_ssl_ca_certs => node['serverdensity']['mongo_ssl_ca_certs'],
                  :mongo_collection_interval => node['serverdensity']['mongo_collection_interval'],
                  )
        notifies :restart, 'service[sd-agent]', :delayed
    end
end

if node['serverdensity']['mysql_server']
    package 'sd-agent-mysql'
    template '/etc/sd-agent/conf.d/mysql.yaml' do
        source 'mysql.yaml.erb'
        owner 'sd-agent'
        group 'sd-agent'
        mode 0644
        variables(
                  :mysql_server => node['serverdensity']['mysql_server'],
                  :mysql_user => node['serverdensity']['mysql_user'],
                  :mysql_pass => node['serverdensity']['mysql_pass'],
                  :mysql_port => node['serverdensity']['mysql_port'],
                  :mysql_sock => node['serverdensity']['mysql_sock'],
                  :mysql_defaults_file => node['serverdensity']['mysql_defaults_file'],
                  :mysql_collection_interval => node['serverdensity']['mysql_collection_interval'],
                  )
        notifies :restart, 'service[sd-agent]', :delayed
    end
end

if node['serverdensity']['nginx_status_url']
    package 'sd-agent-nginx'
    template '/etc/sd-agent/conf.d/nginx.yaml' do
        source 'nginx.yaml.erb'
        owner 'sd-agent'
        group 'sd-agent'
        mode 0644
        variables(
                  :nginx_status_url => node['serverdensity']['nginx_status_url'],
                  :nginx_ssl_validation => node['serverdensity']['nginx_ssl_validation'],
                  :nginx_collection_interval => node['serverdensity']['nginx_collection_interval'],
                  )
        notifies :restart, 'service[sd-agent]', :delayed
    end
end

if node['serverdensity']['ntp_offset_threshold']
    package 'sd-agent-ntp'
    template '/etc/sd-agent/conf.d/ntp.yaml' do
        source 'ntp.yaml.erb'
        owner 'sd-agent'
        group 'sd-agent'
        mode 0644
        variables(
                  :ntp_offset_threshold => node['serverdensity']['ntp_offset_threshold'],
                  :ntp_host => node['serverdensity']['ntp_host'],
                  :ntp_port => node['serverdensity']['ntp_port'],
                  :ntp_version => node['serverdensity']['ntp_version'],
                  :ntp_timeout => node['serverdensity']['ntp_timeout'],
                  :ntp_collection_interval => node['serverdensity']['ntp_collection_interval'],
                  )
        notifies :restart, 'service[sd-agent]', :delayed
    end
end

if node['serverdensity']['phpfpm_status_url']
    package 'sd-agent-phpfpm'
    template '/etc/sd-agent/conf.d/php_fpm.yaml' do
        source 'php_fpm.yaml.erb'
        owner 'sd-agent'
        group 'sd-agent'
        mode 0644
        variables(
                  :phpfpm_status_url => node['serverdensity']['phpfpm_status_url'],
                  :phpfpm_ping_url => node['serverdensity']['phpfpm_ping_url'],
                  :phpfpm_ping_reply => node['serverdensity']['phpfpm_ping_reply'],
                  :phpfpm_user  => node['serverdensity']['phpfpm_user'],
                  :phpfpm_password => node['serverdensity']['phpfpm_password'],
                  :phpfpm_collection_interval => node['serverdensity']['phpfpm_collection_interval'],
                  )
        notifies :restart, 'service[sd-agent]', :delayed
    end
end

if node['serverdensity']['postfix_directory']
    package 'sd-agent-postfix'
    template '/etc/sd-agent/conf.d/postfix.yaml' do
        source 'postfix.yaml.erb'
        owner 'sd-agent'
        group 'sd-agent'
        mode 0644
        variables(
                  :postfix_directory => node['serverdensity']['postfix_directory'],
                  :postfix_queues => node['serverdensity']['postfix_queues'],
                  :postfix_collection_interval => node['serverdensity']['postfix_collection_interval'],
                  )
        notifies :restart, 'service[sd-agent]', :delayed
    end
end

if node['serverdensity']['postgres_host']
    package 'sd-agent-postgresql'
    template '/etc/sd-agent/conf.d/postgres.yaml' do
        source 'postgres.yaml.erb'
        owner 'sd-agent'
        group 'sd-agent'
        mode 0644
        variables(
                  :postgres_host => node['serverdensity']['postgres_host'],
                  :postgres_port => node['serverdensity']['postgres_port'],
                  :postgres_user => node['serverdensity']['postgres_user'],
                  :postgres_password  => node['serverdensity']['postgres_password'],
                  :postgres_dbname => node['serverdensity']['postgres_dbname'],
                  :postgres_ssl => node['serverdensity']['postgres_ssl'],
                  :postgres_collection_interval => node['serverdensity']['postgres_collection_interval'],
                  )
        notifies :restart, 'service[sd-agent]', :delayed
    end
end

if node['serverdensity']['rabbitmq_api_url']
    package 'sd-agent-rabbitmq'
    template '/etc/sd-agent/conf.d/rabbitmq.yaml' do
        source 'rabbitmq.yaml.erb'
        owner 'sd-agent'
        group 'sd-agent'
        mode 0644
        variables(
                  :rabbitmq_api_url => node['serverdensity']['rabbitmq_api_url'],
                  :rabbitmq_user => node['serverdensity']['rabbitmq_user'],
                  :rabbitmq_pass => node['serverdensity']['rabbitmq_pass'],
                  :rabbitmq_nodes => node['serverdensity']['rabbitmq_nodes'],
                  :rabbitmq_nodes_regexes => node['serverdensity']['rabbitmq_nodes_regexes'],
                  :rabbitmq_queues => node['serverdensity']['rabbitmq_queues'],
                  :rabbitmq_queues_regexes => node['serverdensity']['rabbitmq_queues_regexes'],
                  :rabbitmq_collection_interval => node['serverdensity']['rabbitmq_collection_interval'],
                  )
        notifies :restart, 'service[sd-agent]', :delayed
    end
end

if node['serverdensity']['redis_host']
    package 'sd-agent-redis'
    template '/etc/sd-agent/conf.d/redisdb.yaml' do
        source 'redis.yaml.erb'
        owner 'sd-agent'
        group 'sd-agent'
        mode 0644
        variables(
                  :redis_host => node['serverdensity']['redis_host'],
                  :redis_port => node['serverdensity']['redis_port'],
                  :redis_db => node['serverdensity']['redis_db'],
                  :redis_password   => node['serverdensity']['redis_password'],
                  :redis_socket_timeout => node['serverdensity']['redis_socket_timeout'],
                  :redis_slowlog_max_len => node['serverdensity']['redis_slowlog_max_len'],
                  :redis_collection_interval => node['serverdensity']['redis_collection_interval'],
                  )
        notifies :restart, 'service[sd-agent]', :delayed
    end
end

if node['serverdensity']['riak_url']
    package 'sd-agent-riak'
    template '/etc/sd-agent/conf.d/riak.yaml' do
        source 'riak.yaml.erb'
        owner 'sd-agent'
        group 'sd-agent'
        mode 0644
        variables(
                  :riak_url=> node['serverdensity']['riak_url'],
                  )
        notifies :restart, 'service[sd-agent]', :delayed
    end
end

if node['serverdensity']['supervisord_name']
    package 'sd-agent-supervisord'
    template '/etc/sd-agent/conf.d/supervisord.yaml' do
        source 'supervisord.yaml.erb'
        owner 'sd-agent'
        group 'sd-agent'
        mode 0644
        variables(
                  :supervisord_name => node['serverdensity']['supervisord_name'],
                  :supervisord_host => node['serverdensity']['supervisord_host'],
                  :supervisord_port => node['serverdensity']['supervisord_port'],
                  :supervisord_user => node['serverdensity']['supervisord_user'],
                  :supervisord_pass => node['serverdensity']['supervisord_pass'],
                  :supervisord_socket => node['serverdensity']['supervisord_socket'],
                  :supervisord_collection_interval => node['serverdensity']['supervisord_collection_interval'],
                  )
        notifies :restart, 'service[sd-agent]', :delayed
    end
end

if node['serverdensity']['varnishstat_path']
    package 'sd-agent-varnish'
    template '/etc/sd-agent/conf.d/varnish.yaml' do
        source 'varnish.yaml.erb'
        owner 'sd-agent'
        group 'sd-agent'
        mode 0644
        variables(
                  :varnishstat_path => node['serverdensity']['varnishstat_path'],
                  :varnishstat_name => node['serverdensity']['varnishstat_name'],
                  :varnishstat_collection_interval => node['serverdensity']['varnishstat_collection_interval'],
                  )
        notifies :restart, 'service[sd-agent]', :delayed
    end
end

if node['serverdensity']['zk_host']
    package 'sd-agent-zookeeper'
    template '/etc/sd-agent/conf.d/zk.yaml' do
        source 'zk.yaml.erb'
        owner 'sd-agent'
        group 'sd-agent'
        mode 0644
        variables(
                  :zk_host => node['serverdensity']['zk_host'],
                  :zk_port => node['serverdensity']['zk_port'],
                  :zk_timeout => node['serverdensity']['zk_timeout'],
                  :zk_collection_interval => node['serverdensity']['zk_collection_interval'],
                  )
        notifies :restart, 'service[sd-agent]', :delayed
    end
end
