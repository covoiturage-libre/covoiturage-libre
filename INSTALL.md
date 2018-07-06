# Deployment in production

Here is how to use Nginx web server for the production environement.

## Create dedicated deployer user

The first thing we will do on our new server is create the user account we'll be
using to run our applications and work from there.

    apt-get install sudo
    groupadd deployers
    useradd -md /home/deployer -s /bin/bash -G deployers,sudo deployer
    passwd deployer
    su deployer

All commands for deployment described from here will be executed as `deployer`
user.

## Install application dependencies

Install the packages required by the application

    sudo apt-get update
    sudo apt-get install curl gcc g++ make git-core ruby ruby-dev \
      libv8-dev imagemagick file
    gem install bundler
    gem install libv8 -- --with-system-v8

Required ? :

      libpq-dev \
      libapr1-dev zlib1g-dev build-essential libssl-dev \
      libreadline-dev libyaml-dev libsqlite3-dev sqlite3 libxml2-dev libxslt1-dev \
      libcurl4-openssl-dev python-software-properties libffi-dev libaprutil1-dev

## Install Nginx/Phusion Passenger (Debian 8)

Install the PGP key. Packages are signed by "Phusion Automated Software Signing
(auto-software-signing@phusion.nl)",
Add HTTPS support for APT. The APT repository is stored on an HTTPS server.
Secure `passenger.list` and update your APT cache:

    sudo apt-get install nginx
    sudo apt-get install -y dirmngr gnupg
    sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 561F9B9CAC40B2F7
    sudo apt-get install -y apt-transport-https ca-certificates
    sudo sh -c 'echo deb https://oss-binaries.phusionpassenger.com/apt/passenger stretch main > /etc/apt/sources.list.d/passenger.list'
    sudo apt-get update
    sudo apt-get install -y libnginx-mod-http-passenger


Enable the Passenger Nginx module and restart Nginx

    if [ ! -f /etc/nginx/modules-enabled/50-mod-http-passenger.conf ]; then sudo ln -s /usr/share/nginx/modules-available/mod-http-passenger.load /etc/nginx/modules-enabled/50-mod-http-passenger.conf ; fi
    sudo ls /etc/nginx/conf.d/mod-http-passenger.conf

After installation, please validate the install by running `sudo
/usr/bin/passenger-config validate-install`. For example:

    sudo /usr/bin/passenger-config validate-install

## Install PostgreSQL

All you need to do in order to install MySQL is to run the following command:

    sudo apt-get install postgresql

## Capistrano setup

First thing you need to do before deploying the actual code of the application,
you must create the `/opt/covoit-crous` directory with the appropriate
permissions :

    sudo mkdir /opt/covoit-crous
    sudo chown deployer:deployers /opt/covoit-crous

### Client configuration

Follow the installation process on your **local machine** described at the top of this README.

Create a file on your **local machine** named
`config/deploy/production.rb`. Fill this file with following :

    set :stage, :production
    
    role :app, %w{deployer@mytargerserver.domain.or.ip}
    role :web, %w{deployer@mytargerserver.domain.or.ip}
    role :db,  %w{deployer@mytargerserver.domain.or.ip}
    
    server 'mytargerserver.domain.or.ip', user: 'deployer', roles: %w{web app}
    
    set :bundle_env_variables, {
      'https_proxy' => 'http://proxy:port',
      'http_proxy' => 'http://proxy:port'
    }


### Client deployement

You can now deploy the application on the production server using this
command on you local machine :

    cap production deploy

## Configure Nginx host

In order to get Nginx to respond with the Rails app, we need to create a new
site to enable.

Open up `/etc/nginx/sites-available/covoit-crous` in your text editor and we will replace
the file's contents with the following:

    server {
        listen 80 default_server;
        listen [::]:80 default_server ipv6only=on;
    
        server_name covoit-crous.com;
        passenger_enabled on;
        rails_env    production;
        root         /opt/covoit-crous/current/public;
    
        # redirect server error pages to the static page /50x.html
        error_page   500 502 503 504  /50x.html;
        location = /50x.html {
            root   html;
        }
    }

Then enable the new site, like so:

    sudo ln -s /etc/nginx/sites-available/covoit-crous /etc/nginx/sites-enabled/covoit-crous

Once you are done, restart Nginx :

    sudo service nginx restart

## Restart passenger

Last step, you must restart passenger in order to complete de code update :

    touch /opt/covoit-crous/current/tmp/restart.txt

Passenger will restart the application for you. It monitors the file's timestamp
to determine if it should restart the app. This is helpful when you want to
restart the app manually without deploying it.
