


# setup a shared filed system

# after https://www.digitalocean.com/community/tutorials/how-to-set-up-an-nfs-mount-on-ubuntu-16-04

# run on master
apt install nfs-kernel-server
# this will export the directory /root/git to all nodes listed
echo -e "/root 10.20.35.6(sync,no_subtree_check)  
/root 10.20.35.7(sync,no_subtree_check) 
/root 10.20.35.8(sync,no_subtree_check)  
/root 10.20.35.9(sync,no_subtree_check) 
/apps 10.20.35.6(sync,no_subtree_check)  
/apps 10.20.35.7(sync,no_subtree_check) 
/apps 10.20.35.8(sync,no_subtree_check)  
/apps 10.20.35.9(sync,no_subtree_check)
/usr 10.20.35.6(sync,no_subtree_check)  
/usr 10.20.35.7(sync,no_subtree_check) 
/usr 10.20.35.8(sync,no_subtree_check)  
/usr 10.20.35.9(sync,no_subtree_check)" | \
cat >> /etc/exports

exportfs -a

echo "starting nfs server"
systemctl start nfs-kernel-server.service
echo "done starting nfs server"


echo "starting nfs clients"
echo "CAUTION this does not work via SSH"

# run on slaves
declare -a workers=(vm3-8core vm4-8core vm5-8core vm6-8core)
for i in "${workers[@]}"
do
	echo "working on worker $i"
	# ssh root@"$i" apt install nfs-common
	# ssh root@"$i" umount /root/git && umount /root/.julia
	ssh root@"$i" << EOF
		echo "adding mounts to fstab"
		echo -e "10.20.35.11:/root /root nfs auto,nofail,noatime,nolock,intr,tcp,actimeo=1800 0 0" | cat >> /etc/fstab
		echo -e "10.20.35.11:/usr /usr nfs auto,nofail,noatime,nolock,intr,tcp,actimeo=1800 0 0" | cat >> /etc/fstab
		echo -e "10.20.35.11:/apps /apps nfs auto,nofail,noatime,nolock,intr,tcp,actimeo=1800 0 0" | cat >> /etc/fstab
		echo "mounting manually now"
		mount 10.20.35.11:/root /root
		mount 10.20.35.11:/usr /usr
		mkdir -p /apps
		mount 10.20.35.11:/apps /apps
		echo "done. "
EOF
	echo "done. rebooting $i"
	ssh root@"$i" reboot
done