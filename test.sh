declare -a workers=(vm3-8core vm4-8core vm5-8core)
for i in "${workers[@]}"
do
	echo "working on worker $i"
	# ssh root@"$i" apt install nfs-common
	# ssh root@"$i" umount /root/git && umount /root/.julia
	ssh root@"$i" /bin/bash << 'EOT'
	echo "These commands will be run on: $( uname -n )"
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
EOT
done
