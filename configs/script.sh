#!/bin/sh

sudo apt-get -y update
sudo apt-get -y install python-flask git nginx python-virtualenv build-essential python-dev

sudo pip install uwsgi
git clone https://github.com/olive42/moz-flask
sudo mv uwsgi-init.conf /etc/init/uwsgi.conf
sudo start uwsgi

sudo mv moz-nginx.conf /etc/nginx/conf.d/moz-nginx.conf
sudo rm /etc/nginx/sites-enabled/default
sudo kill -HUP $(cat /var/run/nginx.pid)
