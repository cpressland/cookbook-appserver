name             'appserver'
maintainer       'Chris Pressland'
maintainer_email 'mail@cpressland.io'
license          'All rights reserved'
description      'Installs/Configures appserver'
long_description 'Chef Cookbook for configuring and managing the Application Server within my Homelab Environment.'
version          '0.1.0'

depends		'docker'
depends   'yum'
depends   'firewalld'
depends   'selinux'
depends   'patch'
