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
    read_timeout 1200
    write_timeout 1200
    command backup[:command]
  end
end
