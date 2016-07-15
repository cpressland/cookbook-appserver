
default['appserver']['packages'] = %w(wget tar git autofs samba samba-client cifs-utils curl htop vim firewalld)

default['storage']['share_ip'] = "10.0.50.10" # IP Address of unRAID Server
default['storage']['share_name'] = "shared" # Name of Share on unRAID Server

default['smb']['enable_smb'] = true
default['firewalld']['enable_firewalld'] = true

default['appserver']['repositories'] = [
  { :reponame=>"epel", :repodescription=>"Extra Packages for Enterprise Linux", :repobaseurl=>"http://mirrors.ukfast.co.uk/sites/dl.fedoraproject.org/pub/epel/7/x86_64/", :repogpgkey=>"http://dl.fedoraproject.org/pub/epel/RPM-GPG-KEY-EPEL-7"}
]

default['appserver']['users'] = [
  { :name=>"apps", :uid=>1550, :gid=>1550, :home=>"/home/apps" },
  { :name=>"cpressland", :uid=>1551, :gid=>1551, :home=>"/home/cpressland"}
]

default['appserver']['directories'] = [
  { :dirname=>"/downloads", :dirowner=>"apps", :dirgroup=>"apps", :dirmode=>"755" },
  { :dirname=>"/home/cpressland/.ssh", :dirowner=>"cpressland", :dirgroup=>"cpressland", :dirmode=>"700" }
]

default['appserver']['templates'] = [
 { :temname=>"/etc/auto.shared", :temsource=>"conf.auto.shared.erb", :temmode=>"644", :temowner=>"root", :temgroup=>"root"},
 { :temname=>"/etc/auto.master", :temsource=>"conf.auto.master.erb", :temmode=>"644", :temowner=>"root", :temgroup=>"root"},
 { :temname=>"/etc/samba/smb.conf", :temsource=>"conf.smb.conf.erb", :temmode=>"644", :temowner=>"root", :temgroup=>"root"},
 { :temname=>"/usr/lib/systemd/system/autofs.service", :temsource=>"systemd.autofs.service.erb", :temmode=>"644", :temowner=>"root", :temgroup=>"root"},
 { :temname=>"/home/cpressland/.ssh/authorized_keys", :temsource=>"conf.authorized_keys.erb", :temmode=>"600", :temowner=>"cpressland", :temgroup=>"cpressland"}
]

default['firewalld']['firewalld_ports'] = [
  { :fwport=>"32400/tcp", :fwzone=>"public" } # Plex
]

default['firewalld']['firewalld_services'] = [
  { :fwservice=>"ssh", :fwzone=>"public" }, # Local SSH
  { :fwservice=>"http", :fwzone=>"public" }, # Nginx
  { :fwservice=>"https", :fwzone=>"public" }, # Nginx
  { :fwservice=>"samba", :fwzone=>"public" } # Samba
]

default['docker']['images'] = [
  { :name=>"ubuntu", :tag=>"xenial" },
  { :name=>"cpressland/nginx", :tag=>"ubuntu" },
  { :name=>"cpressland/php", :tag=>"ubuntu" },
  { :name=>"mariadb", :tag=>"latest" },
  { :name=>"ghost", :tag=>"latest" },
  { :name=>"cpressland/nzbget", :tag=>"ubuntu" },
  { :name=>"cpressland/sonarr", :tag=>"ubuntu" },
  { :name=>"cpressland/couchpotato", :tag=>"ubuntu" },
  { :name=>"cpressland/plex", :tag=>"ubuntu" },
  { :name=>"cpressland/plexpy", :tag=>"ubuntu" },
  { :name=>"cpressland/netdata", :tag=>"ubuntu" },
  { :name=>"cpressland/1710-pack", :tag=>"ubuntu" }
]

default['docker']['volumes'] = %w(data_databases data_ghost data_www config_nginx config_netdata config_nzbget config_sonarr config_couchpotato config_plex config_plexpy data_minecraft)

default['docker']['restorecontainers'] = [
  { :name=>"restore-data_databases", :repo=>"ubuntu", :tag=>"xenial", :volumes=>['/media/shared/docker:/docker', 'data_databases:/data'], :command=>"/bin/tar xzf /docker/volumes/data_databases.tar.gz -C /data/ ." },
  { :name=>"restore-data_ghost", :repo=>"ubuntu", :tag=>"xenial", :volumes=>['/media/shared/docker:/docker', 'data_ghost:/data'], :command=>"/bin/tar xzf /docker/volumes/data_ghost.tar.gz -C /data/ ." },
  { :name=>"restore-data_www", :repo=>"ubuntu", :tag=>"xenial", :volumes=>['/media/shared/docker:/docker', 'data_www:/data'], :command=>"/bin/tar xzf /docker/volumes/data_www.tar.gz -C /data/ ." },
  { :name=>"restore-data_minecraft", :repo=>"ubuntu", :tag=>"xenial", :volumes=>['/media/shared/docker:/docker', 'data_minecraft:/data'], :command=>"/bin/tar xzf /docker/volumes/data_minecraft.tar.gz -C /data/ ." },
  { :name=>"restore-config_nginx", :repo=>"ubuntu", :tag=>"xenial", :volumes=>['/media/shared/docker:/docker', 'config_nginx:/data'], :command=>"/bin/tar xzf /docker/volumes/config_nginx.tar.gz -C /data/ ." },
  { :name=>"restore-config_nzbget", :repo=>"ubuntu", :tag=>"xenial", :volumes=>['/media/shared/docker:/docker', 'config_nzbget:/data'], :command=>"/bin/tar xzf /docker/volumes/config_nzbget.tar.gz -C /data/ ." },
  { :name=>"restore-config_sonarr", :repo=>"ubuntu", :tag=>"xenial", :volumes=>['/media/shared/docker:/docker', 'config_sonarr:/data'], :command=>"/bin/tar xzf /docker/volumes/config_sonarr.tar.gz -C /data/ ." },
  { :name=>"restore-config_couchpotato", :repo=>"ubuntu", :tag=>"xenial", :volumes=>['/media/shared/docker:/docker', 'config_couchpotato:/data'], :command=>"/bin/tar xzf /docker/volumes/config_couchpotato.tar.gz -C /data/ ." },
  { :name=>"restore-config_plex", :repo=>"ubuntu", :tag=>"xenial", :volumes=>['/media/shared/docker:/docker', 'config_plex:/data'], :command=>"/bin/tar xzf /docker/volumes/config_plex.tar.gz -C /data/ ." },
  { :name=>"restore-config_plexpy", :repo=>"ubuntu", :tag=>"xenial", :volumes=>['/media/shared/docker:/docker', 'config_plexpy:/data'], :command=>"/bin/tar xzf /docker/volumes/config_plexpy.tar.gz -C /data/ ." },
  { :name=>"restore-config_netdata", :repo=>"ubuntu", :tag=>"xenial", :volumes=>['/media/shared/docker:/docker', 'config_netdata:/data'], :command=>"/bin/tar xzf /docker/volumes/config_netdata.tar.gz -C /data/ ." }
]

default['docker']['permanentcontainers'] = [
  { :name=>"mariadb", :repo=>"mariadb", :tag=>"latest", :network_mode=>"cpressland.io", :volumes=>"data_databases:/var/lib/mysql" },
  { :name=>"php", :repo=>"cpressland/php", :tag=>"ubuntu", :network_mode=>"cpressland.io", :volumes=>"data_www:/var/www" },
  { :name=>"ghost", :repo=>"ghost", :tag=>"latest", :network_mode=>"cpressland.io", :volumes=>"data_ghost:/var/lib/ghost" },
  { :name=>"nzbget", :repo=>"cpressland/nzbget", :tag=>"ubuntu", :network_mode=>"cpressland.io", :volumes=>['config_nzbget:/config', '/downloads:/downloads'] },
  { :name=>"sonarr", :repo=>"cpressland/sonarr", :tag=>"ubuntu", :network_mode=>"cpressland.io", :volumes=>['config_sonarr:/config', '/downloads:/downloads', '/media/shared/px01/tv:/tv', '/dev/rtc:/dev/rtc:ro'] },
  { :name=>"couchpotato", :repo=>"cpressland/couchpotato", :tag=>"ubuntu", :network_mode=>"cpressland.io", :volumes=>['config_couchpotato:/config', '/downloads:/downloads', '/media/shared/px01/movies:/movies', '/etc/localtime:/etc/localtime:ro'] },
  { :name=>"plexpy", :repo=>"cpressland/plexpy", :tag=>"ubuntu", :network_mode=>"cpressland.io", :volumes=>"config_plexpy:/config" },
  { :name=>"plex", :repo=>"cpressland/plex", :tag=>"ubuntu", :network_mode=>"host", :volumes=>['config_plex:/config', '/media/shared/px01/tv:/tv', '/media/shared/px01/movies:/movies'] },
  { :name=>"nginx", :repo=>"cpressland/nginx", :tag=>"ubuntu", :network_mode=>"cpressland.io", :port=>['80:80', '443:443'], :volumes=>['data_www:/var/www', 'config_nginx:/etc/nginx'] },
  { :name=>"netdata", :repo=>"cpressland/netdata", :tag=>"ubuntu", :network_mode=>"cpressland.io", :cap_add=>"SYS_PTRACE", :volumes=>['/proc:/host/proc:ro', '/sys:/host/sys:ro', '/var/run/docker.sock:/var/run/docker.sock', 'config_netdata:/etc/netdata/'] },
  { :name=>"minecraft", :repo=>"cpressland/1710-pack", :tag=>"ubuntu", :network_mode=>"cpressland.io", :port=>"25565:25565", :volumes=>"data_minecraft:/var/www" }
]

default['docker']['backupcontainers'] = [
  { :name=>"backup-data_databases", :repo=>"ubuntu", :tag=>"xenial", :volumes=>['/media/shared/docker:/docker', 'data_databases:/data'], :command=>"/bin/tar czf /docker/volumes/data_databases.tar.gz -C /data/ ." },
  { :name=>"backup-data_ghost", :repo=>"ubuntu", :tag=>"xenial", :volumes=>['/media/shared/docker:/docker', 'data_ghost:/data'], :command=>"/bin/tar czf /docker/volumes/data_ghost.tar.gz -C /data/ ." },
  { :name=>"backup-data_www", :repo=>"ubuntu", :tag=>"xenial", :volumes=>['/media/shared/docker:/docker', 'data_www:/data'], :command=>"/bin/tar czf /docker/volumes/data_www.tar.gz -C /data/ ." },
  { :name=>"backup-data_minecraft", :repo=>"ubuntu", :tag=>"xenial", :volumes=>['/media/shared/docker:/docker', 'data_minecraft:/data'], :command=>"/bin/tar czf /docker/volumes/data_minecraft.tar.gz -C /data/ ." },
  { :name=>"backup-config_nginx", :repo=>"ubuntu", :tag=>"xenial", :volumes=>['/media/shared/docker:/docker', 'config_nginx:/data'], :command=>"/bin/tar czf /docker/volumes/config_nginx.tar.gz -C /data/ ." },
  { :name=>"backup-config_nzbget", :repo=>"ubuntu", :tag=>"xenial", :volumes=>['/media/shared/docker:/docker', 'config_nzbget:/data'], :command=>"/bin/tar czf /docker/volumes/config_nzbget.tar.gz -C /data/ ." },
  { :name=>"backup-config_sonarr", :repo=>"ubuntu", :tag=>"xenial", :volumes=>['/media/shared/docker:/docker', 'config_sonarr:/data'], :command=>"/bin/tar czf /docker/volumes/config_sonarr.tar.gz -C /data/ ." },
  { :name=>"backup-config_couchpotato", :repo=>"ubuntu", :tag=>"xenial", :volumes=>['/media/shared/docker:/docker', 'config_couchpotato:/data'], :command=>"/bin/tar czf /docker/volumes/config_couchpotato.tar.gz -C /data/ ." },
  { :name=>"backup-config_plex", :repo=>"ubuntu", :tag=>"xenial", :volumes=>['/media/shared/docker:/docker', 'config_plex:/data'], :command=>"/bin/tar czf /docker/volumes/config_plex.tar.gz -C /data/ ." },
  { :name=>"backup-config_plexpy", :repo=>"ubuntu", :tag=>"xenial", :volumes=>['/media/shared/docker:/docker', 'config_plexpy:/data'], :command=>"/bin/tar czf /docker/volumes/config_plexpy.tar.gz -C /data/ ." },
  { :name=>"backup-config_netdata", :repo=>"ubuntu", :tag=>"xenial", :volumes=>['/media/shared/docker:/docker', 'config_netdata:/data'], :command=>"/bin/tar czf /docker/volumes/config_netdata.tar.gz -C /data/ ." }
]
