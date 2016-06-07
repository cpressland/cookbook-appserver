#
# Cookbook Name:: appserver
# Recipe:: default
#
# Copyright (C) 2016 Chris Pressland
#
# All rights reserved - Do Not Redistribute
#

# --- Attribute Definitions

repovars = node['appserver']['repositories']
uservars = node['appserver']['users']
temvars  = node['appserver']['templates']

# --- Disable SELinux (I'll learn it one day)

selinux_state "Disable SELinux" do
  action :disabled
end

# --- Add Required Users

uservars.each do |createusers|
  group createusers[:name] do
    gid createusers[:gid]
  end

  user createusers[:name] do
    home createusers[:home]
    uid createusers[:uid]
    gid createusers[:gid]
    system false
    shell '/bin/bash'
  end
end

# --- Install Required Yum Repo's

repovars.each do |createrepos|
  yum_repository createrepos[:reponame] do
    description createrepos[:repodescription]
    baseurl createrepos[:repobaseurl]
    gpgkey createrepos[:repogpgkey]
    action :create
  end
end

# --- Install base packages

node['appserver']['packages'].each do |package_name|
  package package_name do
    action :install
  end
end

# --- Deploy Templates

temvars.each do |createtems|
  template createtems[:temname] do
    source createtems[:temsource]
    owner createtems[:temowner]
    group createtems[:temgroup]
    mode createtems[:temmode]
  end
end

directory "/downloads" do
  action :create
  owner "apps"
  group "apps"
  mode "755"
end
