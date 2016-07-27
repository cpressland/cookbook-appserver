#
# Cookbook Name:: appserver
# Recipe:: docker-transient
#
# Copyright (C) 2016 Chris Pressland
#
# All rights reserved - Do Not Redistribute
#

tcontvars = node['docker']['transientcontainers']

tcontvars.each do |transient|
  docker_container transient[:name] do
    repo transient[:repo]
    tag transient[:tag]
    volumes transient[:volumes]
    autoremove true
    read_timeout 12000
    write_timeout 12000
    command transient[:command]
  end
end
