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
dirvars  = node['appserver']['directories']
temvars  = node['appserver']['templates']
fwsvars  = node['firewalld']['firewalld_services']
fwpvars  = node['firewalld']['firewalld_ports']
imgvars  = node['docker']['images']

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

group 'wheel' do
  action :modify
  members 'cpressland'
  append true
end

replace '/etc/sudoers' do
  replace '# %wheel	ALL=(ALL)	NOPASSWD: ALL'
  with    '%wheel	ALL=(ALL)	NOPASSWD: ALL'
end

link '/home/cpressland/Rakefile' do
  to '/var/chef/cookbooks/appserver/Rakefile'
end

# --- Create directories

dirvars.each do |createdirs|
  directory createdirs[:dirname] do
    owner createdirs[:dirowner]
    group createdirs[:dirgroup]
    mode createdirs[:dirmode]
    action :create
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

execute "reload systemd" do
  command "systemctl daemon-reload"
end

# --- Configure Firewalld

service "firewalld" do
  action [:enable, :start]
  only_if { node['firewalld']['enable_firewalld'] }
end

service "firewalld" do
  not_if { node['firewalld']['enable_firewalld'] }
  action [:disable, :stop]
end

fwpvars.each do |fwpconf|
  firewalld_port fwpconf[:fwport] do
    action :add
    zone fwpconf[:fwzone]
    only_if { node['firewalld']['enable_firewalld'] }
  end
end

fwsvars.each do |fwsconf|
  firewalld_service fwsconf[:fwservice] do
    action :add
    zone fwsconf[:fwzone]
    only_if { node['firewalld']['enable_firewalld'] }
  end
end

# --- Enable or Disable SMB

service "smb" do
  only_if { node['smb']['enable_smb'] }
  action [:enable, :start]
end

service "smb" do
  not_if { node['smb']['enable_smb'] }
  action [:disable, :stop]
end

# --- Start AutoFS

service 'autofs' do
  action [:enable, :start]
end

# --- Beginning of Docker Config

docker_service 'default' do
  action [:create, :start]
end

group 'docker' do
  action :modify
  members ['cpressland', 'apps']
  append true
end

docker_network 'cpressland.local' do
  subnet '10.0.51.0/24'
  gateway '10.0.51.1'
  action :create
end

imgvars.each do |dimages|
  docker_image dimages[:name] do
    tag dimages[:tag]
    action :pull
  end
end

node['docker']['volumes'].each do |volume_name|
  docker_volume volume_name do
    action :create
  end
end
