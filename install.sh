#! /bin/bash

yum install -y git
mkdir -p /var/chef/cache
mkdir -p /var/chef/cookbooks
curl -L https://www.chef.io/chef/install.sh | bash -s -- -v 12.7.2
git clone https://github.com/cpressland/cookbook-appserver.git /var/chef/cookbooks/appserver
git clone https://github.com/chef-cookbooks/yum.git /var/chef/cookbooks/yum
git clone https://github.com/rigrassm/firewalld-cookbook.git /var/chef/cookbooks/firewalld
git clone https://github.com/skottler/selinux.git /var/chef/cookbooks/selinux
git clone https://github.com/chef-cookbooks/docker.git /var/chef/cookbooks/docker
git clone https://github.com/chef-cookbooks/compat_resource.git /var/chef/cookbooks/compat_resource
git clone https://github.com/jenssegers/chef-patch.git /var/chef/cookbooks/patch

export PATH=$PATH:/opt/chef/embedded/bin

echo 'Symlinking Rakeifle to /root'
ln -s /var/chef/cookbooks/appserver/Rakefile /root/Rakefile

echo '
{
  "run_list": [ "recipe[appserver::default]" ]
}' > /var/chef/node.json

echo '
  file_cache_path "/root/chef/cache"
  cookbook_path "/root/chef/cookbooks"
  json_attribs "/root/chef/node.json"
' > /var/chef/solo.rb

echo '--- info ---'
echo 'Git & Chef deployment complete, execute "rake -T" for more information'
echo '------------'
