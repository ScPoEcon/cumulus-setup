# set up passwordless SSH across all nodes

# create new key pair on login node
ssh-keygen -t rsa

# copy to all workers
workers = (10.20.35.9, 10.20.35.8, 10.20.35.7, 10.20.35.6)
for i in "${workers[@]}"
do
	cat ~/.ssh/id_rsa.pub | ssh root@$i 'cat >> .ssh/authorized_keys'
done