#
# Cookbook Name:: appserver
# Recipe:: docker-install
#
# Copyright (C) 2016 Chris Pressland
#
# All rights reserved - Do Not Redistribute
#

# Run-once docker installer

docker_service 'default' do
  action [:create, :start]
end

replace "/root/chef/node.json" do
  replace 'recipe[appserver::docker-install]'
  with    'recipe[appserver::default]'
end
