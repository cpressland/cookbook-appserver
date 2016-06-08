
default['appserver']['packages'] = %w(wget tar git autofs samba samba-client cifs-utils curl htop vim firewalld)

default['storage']['share_ip'] = "10.0.50.10" # IP Address of unRAID Server
default['storage']['share_name'] = "shared" # Name of Share on unRAID Server

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
