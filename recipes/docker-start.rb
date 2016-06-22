#
# Cookbook Name:: appserver
# Recipe:: docker-start
#
# Copyright (C) 2016 Chris Pressland
#
# All rights reserved - Do Not Redistribute
#

pcontvars = node['docker']['permanentcontainers']

pcontvars.each do |pcontainers|
 docker_container pcontainers[:name] do
   repo pcontainers[:repo]
   tag pcontainers[:tag]
   port pcontainers[:port]
   network_mode pcontainers[:network_mode]
   links pcontainers[:link]
   cap_add pcontainers[:cap_add]
   volumes pcontainers[:volumes]
   env pcontainers[:env]
   restart_policy 'always'
 end
end
