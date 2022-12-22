echo "admin" | sudo -S sleep 1 && sudo su - root
sleep 2

docker stop miner && docker rm miner && docker image pull quay.io/team-helium/miner:miner-arm64_2022.03.23.1_GA && sudo docker run -d --init --ulimit nofile=64000:64000 --restart always --net host -e OTP_VERSION=23.3.4.7 -e REBAR3_VERSION=3.16.1 --name miner --mount type=bind,source=/home/pi/hnt/miner,target=/var/data --mount type=bind,source=/home/pi/hnt/miner/log,target=/var/log/miner --device /dev/i2c-0  --privileged -v /var/run/dbus:/var/run/dbus --mount type=bind,source=/home/pi/hnt/miner/configs/sys.config,target=/config/sys.config quay.io/team-helium/miner:miner-arm64_2022.03.23.1_GA


echo 'START...'

echo 'HERŞEY BAŞTAN KURULUYOR SAKİN OL :) ...'

apt-get update
apt-get install tcpdump

ftfolder=/home/ft
if [ -d "$ftfolder" ]; then
	echo 'FT KLASORU SILINIYOR ...'
	rm -rf /home/ft/
fi

ftfolder1=/home/ft_pscs
if [ -d "$ftfolder1" ]; then
	echo 'FT KLON KLASORU SILINIYOR ...'
	rm -rf /home/ft_pscs/
fi


cd /home/ && git clone https://github.com/Farukest/ft_pscs.git ft_pscs && mv ft_pscs ft

sleep 1


# gateway_ID Example
# AA555A0000000001

collector_address=
listen_port=16881
gateway_ID=""

chmod 777 /home/ft/hs_ft_pf_conf.json
sed -i 's/replace_collector_address/'"${collector_address}"'/g' /home/ft/hs_ft_pf_conf.json

chmod 777 /home/ft/ftmiddle_configs/conf1.json
sed -i 's/"replace_listen_port_address"/'${listen_port}'/g' /home/ft/ftmiddle_configs/conf1.json

chmod 777 /home/ft/ftmiddle_configs/conf1.json
sed -i 's/"replace_gateway_id"/"'${gateway_ID}'"/g' /home/ft/ftmiddle_configs/conf1.json

chmod 700 /home/ft/first.sh
cd /home/ft/ && ./first.sh



i=0
while [ $i -ne 4 ]
do
		i=$(($i+1))
		
		FILE=/home/ft/hs_ft_pf_$i/Makefile
		if [ -e "$FILE" ]; then
			echo "Makefile exist so may compiled c and obj.. check and remove them.."
			
			# Check pktfwd exist
			PKTFWD=/home/ft/hs_ft_pf_$i/packet_forwarder/lora_pkt_fwd$i
			if [ -e "$PKTFWD" ]; then
				echo "PKTFWD REMOVED.."
				rm -rf /home/ft/hs_ft_pf_$i/packet_forwarder/lora_pkt_fwd$i
			fi 

			# check obj .o exist
			PKTFWDOBJ=/home/hs_ft_pf_$i/packet_forwarder/obj/lora_pkt_fwd$i.o
			if [ -e "$PKTFWDOBJ" ]; then
				echo "PKTFWD .o REMOVED.."
				rm -rf /home/hs_ft_pf_$i/packet_forwarder/obj/lora_pkt_fwd$i.o
			fi 
						
			echo "Making new PKTFWD files and the OBJ .o files.."
			# Create new pktfwd and the obj .o					
			cd /home/ft/hs_ft_pf_$i/ && make -f Makefile
			echo "Making files success.."
			
			
			echo "Maked files moving and keeping and transferring.."
			# Move pktfwd to to tmp and then remove folders and again move pktfwd to folder
			mv /home/ft/hs_ft_pf_$i/packet_forwarder/lora_pkt_fwd$i /tmp/
			rm -rf /home/ft/hs_ft_pf_$i
			mkdir -p /home/ft/hs_ft_pf_$i/packet_forwarder/
			mv /tmp/lora_pkt_fwd$i /home/ft/hs_ft_pf_$i/packet_forwarder/  
			echo "Transferring success.."
		fi       
		
done

echo 'Jobs adding to cron..'
cd /home/ft/ && ./addcron.sh

echo 'SUCCESS THAT IS ALL..'
