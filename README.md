# App Server Chef Cookbook

Chef Cookbook for configuring and managing the Application Server within my Homelab Environment.

# Cookbook Goals:

### OS Customisation
* Fully Patch the Main OS (CentOS 7.2)
* Disable SELinux
* Setup a system Apps User and Group with ID's 1550
* Setup a standard cpressland User and Group with appropriate SSH Keys

### Local Applications
* Install and Configure Samba with AutoFS to connect to persistent storage
  * Mounted under apps user as so relevant containers can read-write
  * Broadcast Downloads Samba Share (/downloads) to remotely access download directory
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
  - Will be used to create backups of all Docker Volumes nightly at 3am to persistent storage

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

Server can be deployed by calling the following script
```
curl -L https://raw.githubusercontent.com/cpressland/cookbook-appserver/master/install.sh | bash
```

## License and Authors

Author:: Chris Pressland (mail@cpressland.io)
