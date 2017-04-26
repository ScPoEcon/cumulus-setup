declare -a workers=(vm4-8core vm5-8core vm6-8core vm7-8core vm8-8core vm9-8core vm10-8core)
for i in "${workers[@]}"
do
	echo "working on worker $i"
	# ssh root@"$i" apt install nfs-common
	# ssh root@"$i" umount /root/git && umount /root/.julia
	ssh root@"$i" /bin/bash << 'EOT'
	echo "These commands will be run on: $( uname -n )"
	apt-get install nfs-common
	echo "mounting now"
	mount 10.20.35.11:/root /root
	mount 10.20.35.11:/usr/local /usr/local
	mkdir -p /apps
	mount 10.20.35.11:/apps /apps
	echo "They are executed by: $( whoami )"
	echo "doing stuff now"
	mkdir -p testing
	cd testing
	touch test.file
	echo "this is the file content" | cat >> test.file
	echo "see whats in it:"
	cat test.file
	cd ..
	rm -rf testing
	echo "done"
	echo ""
	echo ""
EOT
done
