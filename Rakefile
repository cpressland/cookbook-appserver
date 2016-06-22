require 'rake'

container_name = ENV['container']

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

  desc 'Connect to a Docker Container, use --container "container name" to specify the Container'
  task :connect do
      cmd = "docker exec -it #{container_name} /bin/bash"
      system(cmd)
  end

end
