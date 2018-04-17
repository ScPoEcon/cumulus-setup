#!/bin/bash


# mounting /usr only for the R installation, but that also requires /etc/R!


declare -a workers=(m2 m3 m4 m5 m6 m7 m8 m9 m10)
for i in "${workers[@]}"
do
	echo "going to worker $i now"
	ssh floswald@"$i" /bin/bash << 'EOT'
	echo "These commands will be run on: $( uname -n )"
	apt-get --yes install nfs-common
	echo "mounting now"
	mount 10.20.35.34:/home /home
	# mount 10.20.35.34:/usr /usr
	# mkdir -p /etc/R
	# mount 10.20.35.34:/etc/R /etc/R
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
