


# setup a shared filed system

# after https://www.digitalocean.com/community/tutorials/how-to-set-up-an-nfs-mount-on-ubuntu-16-04

# run on master
sudo apt-get install --yes nfs-kernel-server
# this will export the directory /root to all nodes listed
# do manually
rm -rf /etc/exports
echo -e "
/home      10.20.35.11(rw,sync,no_root_squash)
/home      10.20.35.21(rw,sync,no_root_squash)
/home      10.20.35.26(rw,sync,no_root_squash)
/home      10.20.35.27(rw,sync,no_root_squash)
/home      10.20.35.30(rw,sync,no_root_squash)
/home      10.20.35.31(rw,sync,no_root_squash)
/home      10.20.35.32(rw,sync,no_root_squash)
/home      10.20.35.33(rw,sync,no_root_squash)
/home      10.20.35.35(rw,sync,no_root_squash)
/home      10.20.35.36(rw,sync,no_root_squash)" |
cat >> /etc/exports

sudo exportfs -ra

echo "starting nfs server"
sudo systemctl start nfs-kernel-server.service
echo "done starting nfs server"

