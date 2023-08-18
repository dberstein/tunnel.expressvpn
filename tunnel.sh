#!/bin/bash

random_country() {
	expressvpn list all | sed 1,4d | shuf | cut -d\  -f1 | head -1
}

connect() {
	expressvpn connect "$1"
}

echo_ip() {
	echo "$(tput bold)IP ($1): $(curl -s ifconfig.me)$(tput sgr0)"
}

disconnect() {
	expressvpn disconnect
	sleep 1
	systemctl stop expressvpn.service
	sleep 2
	echo_ip disconnect
	exit 0
}


if [ $(id -u) -ne 0 ]; then
	sudo -k
	sudo ${BASH_SOURCE:-$0} $@
	exit 0
fi

systemctl start expressvpn.service
sleep 1
connect "${1:-$(random_country)}"

trap disconnect 1 2 3 6
echo_ip connect
while true; do
	echo -n .
	sleep $((RANDOM/1000))
done
