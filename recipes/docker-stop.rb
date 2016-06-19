#
# Cookbook Name:: appserver
# Recipe:: docker-stop
#
# Copyright (C) 2016 Chris Pressland
#
# All rights reserved - Do Not Redistribute
#

pcontvars = node['docker']['permanentcontainers']

pcontvars.each do |pcontainers|
 docker_container pcontainers[:name] do
   kill_after 30
   action :stop
 end
end
