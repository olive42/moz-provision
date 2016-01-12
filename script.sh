#!/bin/sh

sudo apt-get -y update
sudo apt-get -y install python-flask git
git clone https://github.com/olive42/moz-flask
echo python ./moz-flask/hello.py > hello.log
# python ./moz-flask/hello.py > hello.log 2>&1 &
