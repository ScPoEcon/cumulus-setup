#!/bin/bash
declare -a workers=(vm3-8core vm4-8core vm5-8core vm6-8core vm7-8core vm8-8core vm9-8core vm10-8core)
# declare -a workers=(vm6-8core vm7-8core vm8-8core vm9-8core vm10-8core)
for i in "${workers[@]}"
do
	echo "going to worker $i now"
	ssh root@"$i" /bin/bash << 'EOT'
	echo "These commands will be run on: $( uname -n )"
	apt-get --yes install nfs-common
	echo "mounting now"
	mount 10.20.35.20:/root /root
	mount 10.20.35.20:/usr /usr
	mkdir -p /apps
	mount 10.20.35.20:/apps /apps
	sleep 1
	echo "done mounting. "
	# echo "adding to /etc/ftabs"
	# echo "10.20.35.20:/root /root nfs rw,auto 0 0" | cat >> /etc/fstab
	# echo "10.20.35.20:/usr/local /usr/local nfs rw,auto 0 0" | cat >> /etc/fstab
	# echo "10.20.35.20:/apps /apps nfs rw,auto 0 0" | cat >> /etc/fstab
	echo "done with $i "
	echo " "
	echo " "
	sleep 1
EOT
done
