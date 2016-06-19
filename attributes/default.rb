
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
  { :fwport=>"32400/tcp", :fwzone=>"public" }, # Plex
  { :fwport=>"5050/tcp", :fwzone=>"public" }, # CouchPotato
  { :fwport=>"6789/tcp", :fwzone=>"public" }, # NZBGet
  { :fwport=>"8989/tcp", :fwzone=>"public" }, # Sonarr
  { :fwport=>"9000/tcp", :fwzone=>"public" }, # PHP-FPM
  { :fwport=>"3306/tcp", :fwzone=>"public" }, # MariaDB
  { :fwport=>"2368/tcp", :fwzone=>"public" }, # Ghost
]
default['firewalld']['firewalld_services'] = [
  { :fwservice=>"ssh", :fwzone=>"public" }, # Local SSH
  { :fwservice=>"http", :fwzone=>"public" }, # Nginx
  { :fwservice=>"https", :fwzone=>"public" }, # Nginx
  { :fwservice=>"samba", :fwzone=>"public" } # Samba
]

default['docker']['images'] = [
  { :name=>"ubuntu", :tag=>"xenial" },
  { :name=>"cpressland/nginx", :tag=>"latest" },
  { :name=>"cpressland/php", :tag=>"latest" },
  { :name=>"mariadb", :tag=>"latest" },
  { :name=>"ghost", :tag=>"latest" },
  { :name=>"cpressland/nzbget", :tag=>"latest" },
  { :name=>"cpressland/sonarr", :tag=>"latest" },
  { :name=>"cpressland/couchpotato", :tag=>"latest" },
  { :name=>"cpressland/plex", :tag=>"latest" }
]

default['docker']['volumes'] = %w(data_databases data_ghost data_www config_nginx config_nzbget config_sonarr config_couchpotato config_plex)

default['docker']['restorecontainers'] = [
  { :name=>"restore-data_databases", :repo=>"ubuntu", :tag=>"xenial", :volumes=>['/media/shared/docker:/docker', 'data_databases:/data'], :command=>"/bin/tar xzf /docker/volumes/data_databases.tar.gz -C /data/ ." },
  { :name=>"restore-data_ghost", :repo=>"ubuntu", :tag=>"xenial", :volumes=>['/media/shared/docker:/docker', 'data_ghost:/data'], :command=>"/bin/tar xzf /docker/volumes/data_ghost.tar.gz -C /data/ ." },
  { :name=>"restore-data_www", :repo=>"ubuntu", :tag=>"xenial", :volumes=>['/media/shared/docker:/docker', 'data_www:/data'], :command=>"/bin/tar xzf /docker/volumes/data_www.tar.gz -C /data/ ." },
  { :name=>"restore-config_nginx", :repo=>"ubuntu", :tag=>"xenial", :volumes=>['/media/shared/docker:/docker', 'config_nginx:/data'], :command=>"/bin/tar xzf /docker/volumes/config_nginx.tar.gz -C /data/ ." },
  { :name=>"restore-config_nzbget", :repo=>"ubuntu", :tag=>"xenial", :volumes=>['/media/shared/docker:/docker', 'config_nzbget:/data'], :command=>"/bin/tar xzf /docker/volumes/config_nzbget.tar.gz -C /data/ ." },
  { :name=>"restore-config_sonarr", :repo=>"ubuntu", :tag=>"xenial", :volumes=>['/media/shared/docker:/docker', 'config_sonarr:/data'], :command=>"/bin/tar xzf /docker/volumes/config_sonarr.tar.gz -C /data/ ." },
  { :name=>"restore-config_couchpotato", :repo=>"ubuntu", :tag=>"xenial", :volumes=>['/media/shared/docker:/docker', 'config_couchpotato:/data'], :command=>"/bin/tar xzf /docker/volumes/config_couchpotato.tar.gz -C /data/ ." },
  { :name=>"restore-config_plex", :repo=>"ubuntu", :tag=>"xenial", :volumes=>['/media/shared/docker:/docker', 'config_plex:/data'], :command=>"/bin/tar xzf /docker/volumes/config_plex.tar.gz -C /data/ ." }
]

default['docker']['permanentcontainers'] = [
  { :name=>"mariadb", :repo=>"mariadb", :tag=>"latest", :port=>'3306:3306', :volumes=>"data_databases:/var/lib/mysql" },
  { :name=>"php", :repo=>"cpressland/php", :tag=>"latest", :port=>'9000:9000', :volumes=>"data_www:/var/www" },
  { :name=>"ghost", :repo=>"ghost", :tag=>"latest", :port=>'2368:2368', :volumes=>"data_ghost:/var/lib/ghost" },
  { :name=>"nzbget", :repo=>"cpressland/nzbget", :tag=>"latest", :port=>"6789:6789", :volumes=>['config_nzbget:/config', '/downloads:/downloads'] },
  { :name=>"sonarr", :repo=>"cpressland/sonarr", :tag=>"latest", :port=>"8989:8989", :volumes=>['config_sonarr:/config', '/downloads:/downloads', '/media/shared/px01/tv:/tv', '/dev/rtc:/dev/rtc:ro'] },
  { :name=>"couchpotato", :repo=>"cpressland/couchpotato", :tag=>"latest", :port=>"5050:5050", :volumes=>['config_couchpotato:/config', '/downloads:/downloads', '/media/shared/px01/movies:/movies', '/etc/localtime:/etc/localtime:ro'] },
  { :name=>"plex", :repo=>"cpressland/plex", :tag=>"latest", :network_mode=>"host", :volumes=>['config_plex:/config', '/media/shared/px01/tv:/tv', '/media/shared/px01/movies:/movies'] },
  { :name=>"nginx", :repo=>"cpressland/nginx", :tag=>"latest", :port=>['80:80', '443:443'], :volumes=>['data_www:/var/www', 'config_nginx:/etc/nginx'] }
]

default['docker']['backupcontainers'] = [
  { :name=>"backup-data_databases", :repo=>"ubuntu", :tag=>"xenial", :volumes=>['/media/shared/docker:/docker', 'data_databases:/data'], :command=>"/bin/tar czf /docker/volumes/data_databases.tar.gz -C /data/ ." },
  { :name=>"backup-data_ghost", :repo=>"ubuntu", :tag=>"xenial", :volumes=>['/media/shared/docker:/docker', 'data_ghost:/data'], :command=>"/bin/tar czf /docker/volumes/data_ghost.tar.gz -C /data/ ." },
  { :name=>"backup-data_www", :repo=>"ubuntu", :tag=>"xenial", :volumes=>['/media/shared/docker:/docker', 'data_www:/data'], :command=>"/bin/tar czf /docker/volumes/data_www.tar.gz -C /data/ ." },
  { :name=>"backup-config_nginx", :repo=>"ubuntu", :tag=>"xenial", :volumes=>['/media/shared/docker:/docker', 'config_nginx:/data'], :command=>"/bin/tar czf /docker/volumes/config_nginx.tar.gz -C /data/ ." },
  { :name=>"backup-config_nzbget", :repo=>"ubuntu", :tag=>"xenial", :volumes=>['/media/shared/docker:/docker', 'config_nzbget:/data'], :command=>"/bin/tar czf /docker/volumes/config_nzbget.tar.gz -C /data/ ." },
  { :name=>"backup-config_sonarr", :repo=>"ubuntu", :tag=>"xenial", :volumes=>['/media/shared/docker:/docker', 'config_sonarr:/data'], :command=>"/bin/tar czf /docker/volumes/config_sonarr.tar.gz -C /data/ ." },
  { :name=>"backup-config_couchpotato", :repo=>"ubuntu", :tag=>"xenial", :volumes=>['/media/shared/docker:/docker', 'config_couchpotato:/data'], :command=>"/bin/tar czf /docker/volumes/config_couchpotato.tar.gz -C /data/ ." },
  { :name=>"backup-config_plex", :repo=>"ubuntu", :tag=>"xenial", :volumes=>['/media/shared/docker:/docker', 'config_plex:/data'], :command=>"/bin/tar czf /docker/volumes/config_plex.tar.gz -C /data/ ." }
]
