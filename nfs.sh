# have a shared filed system
# run on master
apt install nfs-kernel-server
# this will export the directory /root/git to all nodes listed
echo -e "/root/git 10.20.35.6(sync,subtree_check)  
/root/git 10.20.35.7(sync,subtree_check) 
/root/git 10.20.35.8(sync,subtree_check)  
/root/git 10.20.35.9(sync,subtree_check)" | \
cat >> /etc/exports

exportfs -a

echo "starting nfs server"
systemctl start nfs-kernel-server.service
echo "done starting nfs server"


echo "starting nfs clients"

# run on slaves
declare -a workers=(vm3-8core vm4-8core vm5-8core vm6-8core)
for i in "${workers[@]}"
do
	echo "on worker $i"
	ssh root@"$i" apt install nfs-common
	ssh root@"$i" mkdir -p git && mount 10.20.35.5:/root/git /root/git
	echo "done."
done
