#!/bin/bash
if [ $(id -u) -eq 0 ]; then
	read -p "Enter username : " username
        pass=$(date +%s | sha256sum | base64 | head -c 6 ; echo)
	egrep "^$username" /etc/passwd >/dev/null
	if [ $? -eq 0 ]; then
		echo "$username exists!"
		exit 1
	else
		useradd -m -s /bin/bash $username
                echo $username:$pass | chpasswd
		if [ $? -eq 0 ]; then
                      echo "User $username has been added to system!"
                      echo "Users password: $pass"
                else 
                      echo "Failed to add a user!"
                      exit 1
                fi
	fi
else
	echo "Only root may add a user to the system"
	exit 2
fi