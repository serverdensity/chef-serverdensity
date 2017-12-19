chef-serverdensity
======================
This cookbook installs the v2 [Server Density](http://www.serverdensity.com/) agent on your Linux systems. This also includes support for the following plugins:

* sd-agent-apache
* sd-agent-btrfs
* sd-agent-consul
* sd-agent-couchbase
* sd-agent-couchdb
* sd-agent-directory
* sd-agent-docker
* sd-agent-elastic
* sd-agent-haproxy
* sd-agent-hdfs
* sd-agent-kafka-consumer
* sd-agent-memcache
* sd-agent-mongo
* sd-agent-mysql
* sd-agent-nginx
* sd-agent-ntp
* sd-agent-phpfpm
* sd-agent-postfix
* sd-agent-postgres
* sd-agent-rabbitmq
* sd-agent-redis
* sd-agent-riak
* sd-agent-supervisord
* sd-agent-varnish
* sd-agent-zookeeper

Requirements
------------
#### Cookbooks
- `apt`
- `yum`
- `dpkg_autostart`

#### Gems
- `rest-client`

#### Platforms:
- Ubuntu
- Debian
- RHEL
- CentOS
- Amazon
- Oracle
- Scientific

> Support for Ubuntu Precise is now deprecated and agent updates are no longer provided after 2.1.6. This cookbook will install agent 2.1.6 for any server detected as Ubuntu Precise

Attributes
----------
#### serverdensity::default
Check `attributes/default.rb` for the full list

Usage
-----
#### serverdensity::default
Just include `serverdensity` in your node's `run_list` to have the agent installed without any configuration:

```json
{
  "name":"my_node",
  "run_list": [
    "recipe[serverdensity]"
  ]
}
```
To install and configure the agent include `serverdensity` in your node's `run_list` and configure the `token` and `sd_account` attributes

Including your API token will allow the cookbook to query the API and generate a new agent key for you, or if the device already exists, return the correct agent key.
You can either specify your account and token in `attributes/default.rb` or you can specify attributes in your `run_list` too:
```json
{
  "name":"my_node",
  "serverdensity": {"token": "b97da80a41c4f61bff05975ee51eb1aa","sd_account":"example"},
  "run_list": [ "recipe[serverdensity]" ]
}
```
You can also include any of the attributes from `attributes/default.rb` in your run list to install and configure plugins. Plugin installation is decided by the presence of the first attribute in the list for the specific plugin:
```json
{
  "name":"my_node",
  "serverdensity": {"token": "b97da80a41c4f61bff05975ee51eb1aa","sd_account":"example","apache_status_url":"http://localhost/server-status?auto"},
  "run_list": [
    "recipe[serverdensity]"
  ]
}
```

Contributing
------------
1. Fork the repository on Github
2. Create a named feature branch (like `add_component_x`)
3. Write your change
4. Write tests for your change (if applicable)
5. Run the tests, ensuring they all pass
6. Submit a Pull Request using Github

License and Authors
-------------------
## References

* [Server Density home page](http://www.serverdensity.com/)
* [akatz/chef-serverdensity](https://github.com/akatz/chef-serverdensity)
* [Jonty/chef-serverdensity](https://github.com/Jonty/chef-serverdensity)
* [serverdensity/chef-serverdensity](https://github.com/serverdensity/chef-serverdensity)

## Authors

* Original Author: Avrohom Katz <iambpentameter@gmail.com>
* Modified by: Jonty Wareing <jonty@jonty.co.uk>
* Modified by: Server Density <hello@serverdensity.com>
* Rewritten by: Mal Graty <mal.graty@googlemail.com>
* Other Contributors:
* [Joe Marty](https://github.com/mltsy)
* Rewritten by: Server Density <hello@serverdensity.com>

## License

[MIT](/LICENSE)