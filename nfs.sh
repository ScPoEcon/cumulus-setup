


# setup a shared filed system

# after https://www.digitalocean.com/community/tutorials/how-to-set-up-an-nfs-mount-on-ubuntu-16-04

# run on master
sudo apt-get install --yes nfs-kernel-server
# this will export the directory /root to all nodes listed
# do manually
# rm -rf /etc/exports
# sudo echo -e "
# /home      10.20.35.11(rw,sync,no_root_squash)" | \
# cat >> /etc/exports

sudo exportfs -ra

echo "starting nfs server"
sudo systemctl start nfs-kernel-server.service
echo "done starting nfs server"


echo "now proceeding to setup clients"
echo ""
sleep 1
./nfs-clients.sh
