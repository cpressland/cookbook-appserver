#
# Cookbook Name:: appserver
# Recipe:: docker-backup
#
# Copyright (C) 2016 Chris Pressland
#
# All rights reserved - Do Not Redistribute
#

bcontvars = node['docker']['backupcontainers']

bcontvars.each do |backup|
  docker_container backup[:name] do
    repo backup[:repo]
    tag backup[:tag]
    volumes backup[:volumes]
    autoremove true
    command backup[:command]
  end
end
