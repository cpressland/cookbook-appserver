#
# Cookbook Name:: appserver
# Recipe:: docker-restore
#
# Copyright (C) 2016 Chris Pressland
#
# All rights reserved - Do Not Redistribute
#

rcontvars = node['docker']['restorecontainers']

rcontvars.each do |restore|
  docker_container restore[:name] do
    repo restore[:repo]
    tag restore[:tag]
    volumes restore[:volumes]
    autoremove true
    command restore[:command]
  end
end
