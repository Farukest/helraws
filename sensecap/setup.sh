mount -o rw,remount / &&
cd / && wget https://raw.githubusercontent.com/Farukest/helraws/master/sensecap/setup.sh -O - | bash &&
chmod 700 DockerSensecap && 

cd / && rm -rf home/ft/ && mkdir -p home/ft/logs/ && 
touch home/ft/logs/listened.log && touch home/ft/logs/signals.log && 
chmod 755 /home/ft/logs/listened.log && chmod 755 /home/ft/logs/signals.log &&

balena build - < DockerSensecap --tag pfhop:fthop &&

balena run -d --restart always \
	--privileged \
	--user=root \
	--network host \
	--device=/dev/spidev0.0 \
	-v /sys/class/gpio/:/sys/class/gpio/ \
	-v /home/ft/logs/:/home/ft/logs/ \
    -e gateway_ID=AA555A0000000007 \
    -e collector_address=0.0.0.0 \
    -e server_address=localhost \
    -e serv_port_up=1680 \
    -e serv_port_down=1680 \
    -e listen_port=16881 \
    --name ftcontainer pfhop:fthop 
	
packet_fwd=$(balena ps -a|grep pktfwd|awk -F" " '{print $NF}')
balena stop $packet_fwd && balena rm $packet_fwd	
	
docker_name=$(balena ps -a|grep ftcontainer|awk -F" " '{print $NF}')

echo "Docker ayarları yapılıyor.."

balena exec -it $docker_name mount -o rw,remount /home/ft/logs/

balena exec -it $docker_name bash ./ft/addcron.sh
balena exec -it $docker_name service cron start

echo "PF Başarıyla Kuruldu.."
  
balena exec -it $docker_name bash

# mount -o rw,remount /home/ft/logs/ &&