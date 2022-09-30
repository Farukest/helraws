mount -o rw,remount / &&
wget https://raw.githubusercontent.com/Farukest/helraws/master/sensecap/dck -P / &&
chmod 700 dck && 

packet_fwd=$(balena ps -a|grep pktfwd|awk -F" " '{print $NF}')
if [ -z "$packet_fwd" ]
then
      echo "\$packet_fwd is NULL"
else
      echo "\$packet_fwd is NOT NULL"
	  balena stop $packet_fwd && balena rm $packet_fwd	
fi

cd / && rm -rf home/ft/ && mkdir -p home/ft/logs/ && 
touch home/ft/logs/listened.log && touch home/ft/logs/signals.log && 
chmod 755 /home/ft/logs/listened.log && chmod 755 /home/ft/logs/signals.log &&

balena build - < dck --tag pfhop:fthop &&

balena run -d --restart always \
	--privileged \
	--user=root \
	--network host \
	--device=/dev/spidev0.0 \
	-v /sys/class/gpio/:/sys/class/gpio/ \
	-v /home/ft/logs/:/home/ft/logs/ \
    -e gateway_ID=$1 \
    -e collector_address=$2 \
    -e server_address=localhost \
    -e serv_port_up=1680 \
    -e serv_port_down=1680 \
    -e listen_port=$3 \
    --name ftcontainer pfhop:fthop 
		
docker_name=$(balena ps -a|grep ftcontainer|awk -F" " '{print $NF}')

echo "Docker ayarları yapılıyor.."

balena exec -it $docker_name mount -o rw,remount /home/ft/logs/

balena exec -it $docker_name bash ./ft/addcron.sh
balena exec -it $docker_name service cron start

echo "PF Başarıyla Kuruldu.."
  
balena exec -it $docker_name bash

# mount -o rw,remount /home/ft/logs/ &&