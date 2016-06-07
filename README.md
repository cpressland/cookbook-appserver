# App Server Chef Cookbook

Chef Cookbook for configuring and managing the Application Server within my Homelab Environment.

# Cookbook Goals:

### OS Customisation
* Fully Patch the Main OS (CentOS 7.2)
* Setup a system Apps User and Group with ID's 1550
* Setup a standard cpressland User and Group with appropriate SSH Keys

### Local Applications
* Install and Configure Samba with AutoFS to connect to persistent storage, mounted under Apps User
* Install and Configure Docker with systemd Scripts for Container Management
* Deploy and Configure [Glances](https://github.com/nicolargo/glances) /w Docker Support

### Permanent Docker Containers
* Deploy and Configure [cpressland/nginx](https://github.com/cpressland/docker-nginx) Docker Container
* Deploy and Configure [cpressland/php](https://github.com/cpressland/docker-php) Docker Container
* Deploy and Configure [docker-library/mariadb](https://github.com/docker-library/mariadb) Docker Container
* Deploy and Configure [docker-library/ghost](https://github.com/docker-library/ghost) Docker Container
* Deploy and Configure [cpressland/nzbget](https://github.com/cpressland/docker-nzbget) Docker Container
* Deploy and Configure [cpressland/sonarr](https://github.com/cpressland/docker-sonarr) Docker Container
* Deploy and Configure [cpressland/couchpotato](https://github.com/cpressland/docker-couchpotato) Docker Container
* Deploy and Configure [cpressland/plex](https://github.com/cpressland/docker-plex) Docker Container
* Deploy and Configure [titpetric/netdata](https://github.com/titpetric/netdata) Docker Container

### Transient Docker Containers
* Deploy and Configure [docker-library/ubuntu](https://hub.docker.com/_/ubuntu/) Docker Container
  - Will be used to create backups of all Docker Volumes nightly at 3am to persistent storage

### Docker Volumes, Mount Points & Connections
* data_downloads
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
