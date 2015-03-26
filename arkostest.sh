#!/usr/bin/env bash

if [[ "$1" == "start" ]] || [[ -z "$1" ]]
then
    echo "Starting test server..."
    cd /home/vagrant/kraken
    python2 krakend -e vagrant --config /home/vagrant/core/settings.json
fi
