#
# Cookbook Name:: serverdensity
# Attributes:: default

default['serverdensity']['agent_key'] = nil
default['serverdensity']['enabled'] = true
default['serverdensity']['sd_account'] = nil
default['serverdensity']['token'] = nil

default['serverdensity']['plugin_dir'] = '/etc/sd-agent/plugins'
default['serverdensity']['plugin_options'] = {}

default['serverdensity']['tmp_directory'] = nil
default['serverdensity']['pidfile_directory'] = nil

default['serverdensity']['log_level'] = 'INFO'

default['serverdensity']['proxy_host'] = nil
default['serverdensity']['proxy_port'] = nil
default['serverdensity']['proxy_user'] = nil
default['serverdensity']['proxy_password'] = nil
default['serverdensity']['proxy_forbid_method_switch'] = nil

default['serverdensity']['hostname'] = nil

default['serverdensity']['collector_log_file'] = '/var/log/sd-agent/collector.log'
default['serverdensity']['forwarder_log_file'] = '/var/log/sd-agent/forwarder.log'

default['serverdensity']['log_to_syslog'] = 'yes'
default['serverdensity']['syslog_host'] = nil
default['serverdensity']['syslog_port'] = nil

default['serverdensity']['listen_port'] = '17124'

default['serverdensity']['device_group'] = nil

# Plugins
default['serverdensity']['apache_status_url'] = nil # Set this attribute to install the Apache plugin
default['serverdensity']['apache_status_user'] = nil
default['serverdensity']['apache_status_pass'] = nil
default['serverdensity']['apache_collection_interval'] = '0'

default['serverdensity']['btrfs_excludes'] = nil # Set this attribute to install the BTRFS plugin

default['serverdensity']['consul_url'] = nil # Set this attribute to install the Consul plugin
default['serverdensity']['consul_checks'] = nil
default['serverdensity']['consul_whitelist'] = []  # Use an array
default['serverdensity']['consul_collection_interval'] = '0'

default['serverdensity']['couchbase_server'] = nil # Set this attribute to install the CouchDB plugin
default['serverdensity']['couchbase_user'] = nil
default['serverdensity']['couchbase_password'] = nil
default['serverdensity']['couchbase_timeout'] = nil
default['serverdensity']['couchbase_collection_interval'] = '0'

default['serverdensity']['couchdb_server'] = nil # Set this attribute to install the CouchDB plugin
default['serverdensity']['couchdb_user'] = nil
default['serverdensity']['couchdb_password'] = nil
default['serverdensity']['couchdb_timeout'] = nil
default['serverdensity']['couchdb_whitelist'] = [] # Use an array
default['serverdensity']['couchdb_blacklist'] = [] # Use an array
default['serverdensity']['couchdb_collection_interval'] = '0'

default['serverdensity']['directory'] = [] # Set this attribute to install the Directory plugin (Use an Array)

default['serverdensity']['docker_root'] = nil # Set this attribute to install the Docker plugin
default['serverdensity']['docker_url'] = nil
default['serverdensity']['docker_collection_interval'] = '0'

default['serverdensity']['elastic_url'] = nil # Set this attribute to install the Elasticsearch plugin
default['serverdensity']['elastic_username'] = nil
default['serverdensity']['elastic_password'] = nil
default['serverdensity']['elastic_cluster_stats'] = nil
default['serverdensity']['elastic_pshard_stats'] = nil
default['serverdensity']['elastic_pending_task_stats'] = nil
default['serverdensity']['elastic_ssl_verify'] = nil
default['serverdensity']['elastic_ssl_cert'] = nil
default['serverdensity']['elastic_ssl_key'] = nil
default['serverdensity']['elastic_timeout'] = nil
default['serverdensity']['elastic_collection_interval'] = '0'

default['serverdensity']['haproxy_url'] = nil # Set this attribute to install the HAProxy Plugin
default['serverdensity']['haproxy_username'] = nil
default['serverdensity']['haproxy_password'] = nil
default['serverdensity']['haproxy_collection_interval'] = '0'

default['serverdensity']['hdfs_datanode_jmx_uri'] = nil # Set this attribute to install the HDFS Plugin
default['serverdensity']['hdfs_namenode_jmx_uri'] = nil
default['serverdensity']['hdfs_collection_interval'] = '0'

default['serverdensity']['kafka_c_connect_str'] = nil # Set this attribute to install the Kafka Consumer plugin
default['serverdensity']['kafka_c_zk_connect_str'] = nil
default['serverdensity']['kafka_c_zk_timeout'] = nil
default['serverdensity']['kafka_c_kafka_timeout'] = nil
default['serverdensity']['kafka_c_my_consumer'] = nil
default['serverdensity']['kafka_c_my_topic'] = nil
default['serverdensity']['kafka_collection_interval'] = '0'

default['serverdensity']['memcache_url'] = nil # Set this attribute to install the Memcache plugin
default['serverdensity']['memcache_collection_interval'] = '0'

default['serverdensity']['mongo_url'] = nil # Set this attribute to install the MongoDB plugin
default['serverdensity']['mongo_timeout'] = nil
default['serverdensity']['mongo_ssl'] = nil
default['serverdensity']['mongo_ssl_keyfile'] = nil
default['serverdensity']['mongo_ssl_cert'] = nil
default['serverdensity']['mongo_ssl_cert_reqs'] = nil
default['serverdensity']['mongo_ssl_ca_certs'] = nil
default['serverdensity']['mongo_collection_interval'] = '0'

default['serverdensity']['mysql_server'] = nil # Set this attribute to install the MySQL/MariaDB plugin
default['serverdensity']['mysql_user'] = nil
default['serverdensity']['mysql_pass'] = nil
default['serverdensity']['mysql_port'] = nil
default['serverdensity']['mysql_sock'] = nil
default['serverdensity']['mysql_defaults_file'] = nil
default['serverdensity']['mysql_collection_interval'] = '0'

default['serverdensity']['nginx_status_url'] = nil # Set this attribute to install the Nginx plugin
default['serverdensity']['nginx_ssl_validation'] = nil
default['serverdensity']['nginx_collection_interval'] = '0'

default['serverdensity']['ntp_offset_threshold'] = nil # Set this attribute to install the NTP plugin
default['serverdensity']['ntp_host'] = nil
default['serverdensity']['ntp_port'] = nil
default['serverdensity']['ntp_version'] = nil
default['serverdensity']['ntp_timeout'] = nil
default['serverdensity']['ntp_collection_interval'] = '0'

default['serverdensity']['phpfpm_status_url'] = nil # Set this attribute to install the PHPFPM plugin
default['serverdensity']['phpfpm_ping_url'] = nil
default['serverdensity']['phpfpm_ping_reply'] = nil
default['serverdensity']['phpfpm_user'] = nil
default['serverdensity']['phpfpm_password'] = nil
default['serverdensity']['phpfpm_collection_interval'] = '0'

default['serverdensity']['postfix_directory'] = nil # Set this attribute to install the Postfix plugin
default['serverdensity']['postfix_queues'] = ["incoming","deferred","active"] # Use an array
default['serverdensity']['postfix_collection_interval'] = '0'

default['serverdensity']['postgres_host'] = nil # Set this attribute to install the Postgres plugin
default['serverdensity']['postgres_port'] = nil
default['serverdensity']['postgres_user'] = nil
default['serverdensity']['postgres_password'] = nil
default['serverdensity']['postgres_dbname'] = nil
default['serverdensity']['postgres_ssl'] = nil
default['serverdensity']['postgres_collection_interval'] = '0'

default['serverdensity']['rabbitmq_api_url'] = nil # Set this attribute to install the RabbitMQ plugin
default['serverdensity']['rabbitmq_user'] = nil
default['serverdensity']['rabbitmq_pass'] = nil
default['serverdensity']['rabbitmq_nodes'] = [] # Use an array
default['serverdensity']['rabbitmq_nodes_regexes'] = [] # Use an array
default['serverdensity']['rabbitmq_queues'] = [] # Use an array
default['serverdensity']['rabbitmq_queues_regexes'] = [] # Use an array
default['serverdensity']['rabbitmq_collection_interval'] = '0'

default['serverdensity']['redis_host'] = nil # Set this attribute to install the Redis plugin
default['serverdensity']['redis_port'] = nil
default['serverdensity']['redis_db'] = nil
default['serverdensity']['redis_password'] = nil
default['serverdensity']['redis_sock'] = nil
default['serverdensity']['redis_socket_timeout'] = nil
default['serverdensity']['redis_slowlog_max_len'] = nil
default['serverdensity']['redis_collection_interval'] = '0'

default['serverdensity']['riak_url'] = nil # Set this attribute to install the Riak plugin

default['serverdensity']['supervisord_name'] = nil # Set this attribute to install the Supervisord plugin
default['serverdensity']['supervisord_host'] = nil
default['serverdensity']['supervisord_port'] = nil
default['serverdensity']['supervisord_user'] = nil
default['serverdensity']['supervisord_pass'] = nil
default['serverdensity']['supervisord_socket'] = nil
default['serverdensity']['supervisord_collection_interval'] = '0'

default['serverdensity']['varnishstat_path'] = nil # Set this attribute to install the Varnish plugin
default['serverdensity']['varnishstat_name'] = nil
default['serverdensity']['varnishstat_collection_interval'] = '0'

default['serverdensity']['zk_host'] = nil # Set this attribute to install the Zookeeper plugin
default['serverdensity']['zk_port'] = nil
default['serverdensity']['zk_timeout'] = nil
default['serverdensity']['zk_collection_interval'] = '0'
