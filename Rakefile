require 'rake'

puts " "
puts "--- Information ---"
puts "Usage:"
puts "Run 'rake server:provision' to build the base server configuration"
puts "restore volumes with 'rake docker:restore'"
puts "backup volumes with 'rake docker:backup'"
puts "start all docker containers with 'rake docker:start'"
puts "-------------------"
puts " "

namespace :server do

  desc 'Install Essential Components'
  task :provision do
    cmd = 'sudo chef-solo -c /var/chef/solo.rb -j /var/chef/node.json --override-runlist "recipe[appserver::default]"'
    system(cmd)
  end

end

namespace :docker do

  desc 'Restore Docker Volumes from Network'
  task :restore do
    cmd = 'sudo chef-solo -c /var/chef/solo.rb -j /var/chef/node.json --override-runlist "recipe[appserver::docker-restore]"'
    system(cmd)
  end

  desc 'Backup Docker Volumes to Network'
  task :backup do
    cmd = 'sudo chef-solo -c /var/chef/solo.rb -j /var/chef/node.json --override-runlist "recipe[appserver::docker-backup]"'
    system(cmd)
  end

  desc 'Start All Docker Containers'
  task :start do
    cmd = 'sudo chef-solo -c /var/chef/solo.rb -j /var/chef/node.json --override-runlist "recipe[appserver::docker-start]"'
    system(cmd)
  end

  desc 'Stop All Docker Containers'
  task :stop do
    cmd = 'sudo chef-solo -c /var/chef/solo.rb -j /var/chef/node.json --override-runlist "recipe[appserver::docker-stop]"'
    system(cmd)
  end

  desc 'Stop and Delete All Docker Containers (Preserves Docker Volumes)'
  task :destroy do
    cmd = 'sudo chef-solo -c /var/chef/solo.rb -j /var/chef/node.json --override-runlist "recipe[appserver::docker-destroy]"'
    system(cmd)
  end

end
