# docker stop miner && docker rm miner && docker image pull quay.io/team-helium/miner:miner-arm64_2022.03.23.1_GA && sudo docker run -d --init --ulimit nofile=64000:64000 --restart always --net host -e OTP_VERSION=23.3.4.7 -e REBAR3_VERSION=3.16.1 --name miner --mount type=bind,source=/home/pi/hnt/miner,target=/var/data --mount type=bind,source=/home/pi/hnt/miner/log,target=/var/log/miner --device /dev/i2c-0  --privileged -v /var/run/dbus:/var/run/dbus --mount type=bind,source=/home/pi/hnt/miner/configs/sys.config,target=/config/sys.config quay.io/team-helium/miner:miner-arm64_2022.03.23.1_GA


echo 'START...'

echo $1
echo $2
echo $3


echo 'SUCCESS THAT IS ALL..'
