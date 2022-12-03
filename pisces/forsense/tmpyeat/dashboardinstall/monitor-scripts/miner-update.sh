#!/bin/bash
service=$(cat /var/dashboard/services/miner-update | tr -d '\n')
version=$(cat /var/dashboard/statuses/latest_miner_version | tr -d '\n')

if [[ $service == 'start' ]]; then
  echo 'running' > /var/dashboard/services/miner-update
  echo 'Stopping currently running docker...' > /var/dashboard/logs/miner-update.log
  docker stop miner >> /var/dashboard/logs/miner-update.log
  currentdockerstatus=$(sudo docker ps -a -f name=miner --format "{{ .Status }}")
  if [[ $currentdockerstatus =~ 'Exited' || $currentdockerstatus == '' ]]; then
    echo 'Backing up current config...' >> /var/dashboard/logs/miner-update.log
    currentconfig=$(sudo docker inspect miner | grep sys.config | grep -Po '"Source": ".*\/sys.config' | sed 's/"Source": "//' | sed -n '1p')
    mkdir /home/pi/hnt/miner/configs
    mkdir /home/pi/hnt/miner/configs/previous_configs
    currentversion=$(docker ps -a -f name=miner --format "{{ .Image }}" | grep -Po 'miner: *.+' | sed 's/miner://')
    cp "$currentconfig" "/home/pi/hnt/miner/configs/previous_configs/$currentversion.config" >> /var/dashboard/logs/miner-update.log
    echo 'Acquiring latest Helium config from GitHub...' >> /var/dashboard/logs/miner-update.log
    cp -v /tmp/sys.config /home/pi/hnt/miner/configs/
    # wget /tmp/sys.config -O /home/pi/hnt/miner/configs/sys.config >> /var/dashboard/logs/miner-update.log
    echo 'Removing currently running docker...' >> /var/dashboard/logs/miner-update.log
    docker rm miner
    echo 'Acquiring and starting latest docker version...' >> /var/dashboard/logs/miner-update.log
    docker image pull quay.io/team-helium/miner:$version >> /var/dashboard/logs/miner-update.log
    docker run -d --init --ulimit nofile=64000:64000 --restart always --net host -e OTP_VERSION=23.3.4.7 -e REBAR3_VERSION=3.16.1 --name miner --mount type=bind,source=/home/pi/hnt/miner,target=/var/data --mount type=bind,source=/home/pi/hnt/miner/log,target=/var/log/miner --device /dev/i2c-1  --privileged -v /var/run/dbus:/var/run/dbus --mount type=bind,source=/home/pi/hnt/miner/configs/sys.config,target=/config/sys.config quay.io/team-helium/miner:$version >> /var/dashboard/logs/miner-update.log

    currentdockerstatus=$(sudo docker ps -a -f name=miner --format "{{ .Status }}")
    if [[ $currentdockerstatus =~ 'Up' ]]; then
      echo 'Removing old docker firmware image to save space ...' >> /var/dashboard/logs/miner-update.log
      docker rmi $(docker images -q quay.io/team-helium/miner:$currentversion)
      echo 'stopped' > /var/dashboard/services/miner-update
      echo $version > /var/dashboard/statuses/current_miner_version
      echo "DISTRIB_RELEASE=$(echo $version | sed -e 's/miner-arm64_//' | sed -e 's/_GA//')" > /etc/lsb_release
      echo 'Update complete.' >> /var/dashboard/logs/miner-update.log
    else
      echo 'stopped' > /var/dashboard/services/miner-update
      echo 'Miner docker failed to start.  Check logs to investigate.'
    fi
  else
    echo 'stopped' > /var/dashboard/services/miner-update
    echo 'Error: Could not stop docker.' >> /var/dashboard/logs/miner-update.log
  fi
fi
