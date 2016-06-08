
default['appserver']['packages'] = %w(wget tar git autofs samba samba-client cifs-utils curl htop vim firewalld)

default['storage']['share_ip'] = "10.0.50.10" # IP Address of unRAID Server
default['storage']['share_name'] = "shared" # Name of Share on unRAID Server

default['mysql']['root_pass'] = "Password1" # Placeholder, overwritten during deployment

default['smb']['enable_smb'] = true
default['firewalld']['enable_firewalld'] = true

default['appserver']['repositories']   = [
  { :reponame=>"epel", :repodescription=>"Extra Packages for Enterprise Linux", :repobaseurl=>"http://mirrors.ukfast.co.uk/sites/dl.fedoraproject.org/pub/epel/7/x86_64/", :repogpgkey=>"http://dl.fedoraproject.org/pub/epel/RPM-GPG-KEY-EPEL-7"}
]

default['appserver']['users']          = [
  { :name=>"apps", :uid=>1550, :gid=>1550, :home=>"/home/apps" },
  { :name=>"cpressland", :uid=>1551, :gid=>1551, :home=>"/home/cpressland"}
]

default['appserver']['templates']    = [
 { :temname=>"/etc/auto.shared", :temsource=>"conf.auto.shared.erb", :temmode=>"644", :temowner=>"root", :temgroup=>"root"},
 { :temname=>"/etc/auto.master", :temsource=>"conf.auto.master.erb", :temmode=>"644", :temowner=>"root", :temgroup=>"root"},
 { :temname=>"/etc/samba/smb.conf", :temsource=>"conf.smb.conf.erb", :temmode=>"644", :temowner=>"root", :temgroup=>"root"}
]

default['firewalld']['firewalld_ports']          =  [
  { :fwport=>"32400/tcp", :fwzone=>"public" }, # Plex
  { :fwport=>"5050/tcp", :fwzone=>"public" }, # CouchPotato
  { :fwport=>"6789/tcp", :fwzone=>"public" }, # NZBGet
  { :fwport=>"8989/tcp", :fwzone=>"public" } # Sonarr
]
default['firewalld']['firewalld_services']       =  [
  { :fwservice=>"ssh", :fwzone=>"public" }, # Local SSH
  { :fwservice=>"http", :fwzone=>"public" }, # Nginx
  { :fwservice=>"https", :fwzone=>"public" }, # Nginx
  { :fwservice=>"samba", :fwzone=>"public" } # Samba
]

default['docker']['images']    = [
  { :name=>"ubuntu", :tag=>"xenial" },
  { :name=>"cpressland/nginx", :tag=>"latest" },
  { :name=>"cpressland/php", :tag=>"latest" },
  { :name=>"mariadb", :tag=>"latest" },
  { :name=>"ghost", :tag=>"latest" },
  { :name=>"cpressland/nzbget", :tag=>"latest" },
  { :name=>"cpressland/sonarr", :tag=>"latest" },
  { :name=>"cpressland/couchpotato", :tag=>"latest" },
  { :name=>"cpressland/plex", :tag=>"latest" },
  { :name=>"titpetric/netdata", :tag=>"latest" }
]

default['docker']['volumes'] = %w(data_databases data_ghost data_www config_nginx config_nzbget config_sonarr config_couchpotato config_plex)

default['docker']['containers'] = [
  { :name=>"mariadb", :repo=>"mariadb", :tag=>"latest", :volumes=>"data_databases:/var/lib/mysql", :env=>"MYSQL_ROOT_PASSWORD=#{default['mysql']['root_pass']}" },
  { :name=>"php", :repo=>"cpressland/php", :tag=>"latest", :link=>"mariadb", :volumes=>"data_www:/var/www" },
  { :name=>"ghost", :repo=>"ghost", :tag=>"latest", :volumes=>"data_ghost:/var/lib/ghost" },
  { :name=>"nzbget", :repo=>"cpressland/nzbget", :tag=>"latest", :port=>"6789:6789", :volumes=>"config_nzbget:/config" },
  { :name=>"sonarr", :repo=>"cpressland/sonarr", :tag=>"latest", :port=>"8989:8989", :volumes=>['config_sonarr:/config', '/dev/rtc:/dev/rtc:ro'] },
  { :name=>"couchpotato", :repo=>"cpressland/couchpotato", :tag=>"latest", :port=>"5050:5050", :volumes=>['config_couchpotato:/config', '/etc/localtime:/etc/localtime:ro'] },
  { :name=>"plex", :repo=>"cpressland/plex", :tag=>"latest", :port=>"32400:32400", :volumes=>"config_plex:/config" },
  { :name=>"netdata", :repo=>"titpetric/netdata", :tag=>"latest", :volumes=>['/proc:/host/proc:ro', '/sys:/host/sys:ro'] },
  { :name=>"nginx", :repo=>"cpressland/nginx", :tag=>"latest", :link=>['php', 'ghost', 'nzbget', 'sonarr', 'couchpotato', 'netdata'], :port=>['80:80', '443:443'], :volumes=>['data_www:/var/www', 'config_nginx:/etc/nginx'] } # Start Nginx Last due to Link dependencies
]
