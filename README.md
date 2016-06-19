# App Server Chef Cookbook

Chef Cookbook for configuring and managing the Application Server within my Homelab Environment.

# Cookbook Goals:

### OS Customisation
* Disable SELinux
* Setup a system user (apps)
  - UID = 1550
  - GID = 1550
* Setup a personal user (cpressland)
  - UID = 1551
  - GID = 1551
  - Install SSH Key
  - Add to wheel group
  - Add to docker group
* Update Sudoers file to let members of the 'wheel' group run sudo without a password


### Local Applications
* Install and Configure Samba
  - Configure Samba for guess only access, map guest to 'apps' user.
  - Broadcast Downloads Share (/downloads)
* Install and Configure AutoFS
  - Replace default autofs.service systemd service file
    * Add "before=docker.service" to let AutoFS start before Docker
    * Add "ExecStartPost=" option to mount persistent storage immediately
  - Mount network share as 'apps' user
* Install and Configure Docker

### Permanent Docker Containers
* Deploy and Configure [cpressland/nginx](https://hub.docker.com/r/cpressland/nginx/) Docker Container
* Deploy and Configure [cpressland/php](https://hub.docker.com/r/cpressland/php/) Docker Container
* Deploy and Configure [docker-library/mariadb](https://hub.docker.com/_/mariadb/) Docker Container
* Deploy and Configure [docker-library/ghost](https://hub.docker.com/_/ghost/) Docker Container
* Deploy and Configure [cpressland/nzbget](https://hub.docker.com/r/cpressland/nzbget/) Docker Container
* Deploy and Configure [cpressland/sonarr](https://hub.docker.com/r/cpressland/sonarr/) Docker Container
* Deploy and Configure [cpressland/couchpotato](https://hub.docker.com/r/cpressland/couchpotato/) Docker Container
* Deploy and Configure [cpressland/plex](https://hub.docker.com/r/cpressland/plex/) Docker Container

### Transient Docker Containers
* Deploy and Configure [docker-library/ubuntu](https://hub.docker.com/_/ubuntu/) Docker Container
  - Used for restore of data from persistent storage to Docker Volumes
  - Used for backup of data from Docker Volumes to persistent storage

### Docker Volumes, Mount Points & Connections
* /downloads
  * /downloads
    * cpressland/nzbget
    * cpressland/sonarr
    * cpressland/couchpotato
* data_databases
  * /var/lib/mysql
    * docker-library/mariadb
* data_ghost
  * /var/lib/ghost
    * docker-library/ghost
* data_www
  * /var/www
    * cpressland/nginx
    * cpressland/php
* config_nginx
  * /etc/nginx
    * cpressland/nginx
* config_nzbget
  * /config
    * cpressland/nzbget
* config_sonarr
  * /config
    * cpressland/sonarr
* config_couchpotato
  * /config
    * cpressland/couchpotato
* config_plex
  * /config
    * cpressland/plex

## Supported Platforms

CentOS 7.2.1511

## Usage

Server can be bootstrapped with the following command:

```
curl -L https://raw.githubusercontent.com/cpressland/cookbook-appserver/master/install.sh | bash
```

Once the script has finished various Rake Tasks are available:

* `rake server:provision` - runs the 'default' recipe, essential
* `rake docker:restore` - Restores data to Docker Volumes from SMB Network Share
* `rake docker:backup` - Backs up data from Docker Volumes to SMB Network Share
* `rake docker:start` - Starts all configured Docker Containers
* `rake docker:stop` - Stops all chef configured Docker Containers
* `rake docker:destroy` - Stops and Removes all Docker Containers

## Author

Author:: Chris Pressland (mail@cpressland.io)
