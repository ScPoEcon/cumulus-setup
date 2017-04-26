# set up passwordless SSH across all nodes

# create new key pair on login node
# don't put in a password when asked.
# ssh-keygen -t rsa

# # task 1: setup SSH between login and worker nodes

# declare -a workers=(vm3-8core vm4-8core vm5-8core vm6-8core)
# for i in "${workers[@]}"
# do
# 	echo "setting up SSH on worker $i"
# 	cat ~/.ssh/id_rsa.pub | ssh root@"$i" 'cat >> .ssh/authorized_keys'
# 	echo "done."
# done


declare -a workers=(vm6-8core vm7-8core vm8-8core vm9-8core vm10-8core)
for i in "${workers[@]}"
do
	echo "working on worker $i"
	cat ~/.ssh/id_rsa.pub | ssh root@"$i" 'cat >> .ssh/authorized_keys'
	# ssh root@"$i" apt install nfs-common
	# ssh root@"$i" umount /root/git && umount /root/.julia
	echo "done"
EOT
done
