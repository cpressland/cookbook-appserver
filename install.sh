#! /bin/bash

yum install -y git
mkdir -p /root/chef/cache
mkdir -p /root/chef/cookbooks
curl -L https://www.chef.io/chef/install.sh | bash -s -- -v 12.7.2
git clone https://github.com/cpressland/cookbook-appserver.git /root/chef/cookbooks/appserver
git clone https://github.com/chef-cookbooks/yum.git /root/chef/cookbooks/yum
git clone https://github.com/rigrassm/firewalld-cookbook.git /root/chef/cookbooks/firewalld
git clone https://github.com/skottler/selinux.git /root/chef/cookbooks/selinux
git clone https://github.com/chef-cookbooks/docker.git /root/chef/cookbooks/docker
git clone https://github.com/chef-cookbooks/compat_resource.git /root/chef/cookbooks/compat_resource
git clone https://github.com/jenssegers/chef-patch.git /root/chef/cookbooks/patch


echo '
{
  "docker": {
    "first_run": true,
    "restore_volumes": true
  },
  "run_list": [ "recipe[appserver::docker-install]" ]
}' > /root/chef/node.json


echo '
  file_cache_path "/root/chef/cache"
  cookbook_path "/root/chef/cookbooks"
  json_attribs "/root/chef/node.json"
' > /root/chef/solo.rb

sudo chef-solo -c /root/chef/solo.rb -j /root/chef/node.json
