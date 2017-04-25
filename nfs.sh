


# setup a shared filed system

# after https://www.digitalocean.com/community/tutorials/how-to-set-up-an-nfs-mount-on-ubuntu-16-04

# run on master
apt install nfs-kernel-server
# this will export the directory /root/git to all nodes listed
rm -rf /etc/exports
echo -e "/root 10.20.35.6(rw,sync,no_subtree_check,no_root_squash)  
/root 10.20.35.7(rw,sync,no_subtree_check,no_root_squash) 
/root 10.20.35.8(rw,sync,no_subtree_check,no_root_squash)  
/root 10.20.35.12(rw,sync,no_subtree_check,no_root_squash) 
/root 10.20.35.13(rw,sync,no_subtree_check,no_root_squash) 
/root 10.20.35.14(rw,sync,no_subtree_check,no_root_squash) 
/root 10.20.35.15(rw,sync,no_subtree_check,no_root_squash) 
/root 10.20.35.16(rw,sync,no_subtree_check,no_root_squash) 
/apps 10.20.35.6(rw,sync,no_subtree_check,no_root_squash)  
/apps 10.20.35.7(rw,sync,no_subtree_check,no_root_squash) 
/apps 10.20.35.8(rw,sync,no_subtree_check,no_root_squash)  
/apps 10.20.35.12(rw,sync,no_subtree_check,no_root_squash)
/apps 10.20.35.13(rw,sync,no_subtree_check,no_root_squash)
/apps 10.20.35.14(rw,sync,no_subtree_check,no_root_squash)
/apps 10.20.35.15(rw,sync,no_subtree_check,no_root_squash)
/apps 10.20.35.16(rw,sync,no_subtree_check,no_root_squash)" | \
cat >> /etc/exports

exportfs -a

echo "starting nfs server"
systemctl start nfs-kernel-server.service
echo "done starting nfs server"


echo "starting nfs clients"
echo "CAUTION this does not work via SSH?"

# run on slaves
declare -a workers=(vm3-8core vm4-8core vm5-8core vm6-8core vm7-8core vm8-8core vm9-8core vm10-8core)
for i in "${workers[@]}"
do
	echo "working on worker $i"
	# ssh root@"$i" apt install nfs-common
	# ssh root@"$i" umount /root/git && umount /root/.julia
	ssh root@"$i" << EOF
		echo "mounting manually now"
		mount 10.20.35.11:/root /root
		mkdir -p /apps
		mount 10.20.35.11:/apps /apps
		echo "done. "
EOF
	# echo "done. rebooting $i"
	# ssh root@"$i" reboot
done

# manually do that
		# echo -e "10.20.35.11:/root /root nfs nofail,noatime,nolock,intr,tcp,actimeo=1800 0 0" | cat >> /etc/fstab
		# echo -e "10.20.35.11:/usr /usr nfs nofail,noatime,nolock,intr,tcp,actimeo=1800 0 0" | cat >> /etc/fstab
		# echo -e "10.20.35.11:/apps /apps nfs nofail,noatime,nolock,intr,tcp,actimeo=1800 0 0" | cat >> /etc/fstab
