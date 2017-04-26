declare -a workers=(vm3-8core vm4-8core vm5-8core vm6-8core vm7-8core vm8-8core vm9-8core vm10-8core)
for i in "${workers[@]}"
do
	echo "working on worker $i"
	# ssh root@"$i" apt install nfs-common
	# ssh root@"$i" umount /root/git && umount /root/.julia
	ssh root@"$i" << EOF
		echo "doing stuff now"
		mkdir -p testing
		cd testing
		touch test.file
		echo "put that into it" | cat >> test.file
		echo "see whats in it"
		cat test.file
		cd ..
		rm -rf testing
		echo "done"
EOF
done
