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
fwsvars  = node['firewalld']['firewalld_services']
fwpvars  = node['firewalld']['firewalld_ports']
imgvars  = node['docker']['images']
pcontvars = node['docker']['permanentcontainers']
bcontvars = node['docker']['backupcontainers']

# --- Disable SELinux (I'll learn it one day)

selinux_state "Disable SELinux" do
  action :disabled
end

docker_service 'default' do
  action :stop
  only_if { node['appserver']['first_run'] }
end

replace "/root/chef/node.json" do
  replace '"first_run": true,'
  with    '"first_run": false,'
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

execute "reload systemd" do
  command "systemctl daemon-reload"
end

directory "/downloads" do
  action :create
  owner "apps"
  group "apps"
  mode "755"
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
  action :start
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

pcontvars.each do |pcontainers|
 docker_container pcontainers[:name] do
   repo pcontainers[:repo]
   tag pcontainers[:tag]
   port pcontainers[:port]
   network_mode pcontainers[:network_mode]
   links pcontainers[:link]
   volumes pcontainers[:volumes]
   env pcontainers[:env]
   restart_policy 'always'
 end
end

bcontvars.each do |backup|
  docker_container backup[:name] do
    repo backup[:repo]
    tag backup[:tag]
    volumes backup[:volumes]
    autoremove true
    command backup[:command]
    only_if { node['docker']['backup_volumes'] }
  end
end
