


# setup a shared filed system

# after https://www.digitalocean.com/community/tutorials/how-to-set-up-an-nfs-mount-on-ubuntu-16-04

# run on master
apt install --yes nfs-kernel-server
# this will export the directory /root to all nodes listed
rm -rf /etc/exports
echo -e "
/root      10.20.35.12/19.19.19.0(rw,sync,no_root_squash)
/usr       10.20.35.12/19.19.19.0(ro,sync,no_root_squash)
/etc/R       10.20.35.12/19.19.19.0(ro,sync,no_root_squash)
/apps      10.20.35.12/19.19.19.0(ro,sync,no_root_squash)" | \
cat >> /etc/exports

exportfs -a

echo "starting nfs server"
systemctl start nfs-kernel-server.service
echo "done starting nfs server"


echo "now proceeding to setup clients"
echo ""
sleep 1
./nfs-clients.sh
