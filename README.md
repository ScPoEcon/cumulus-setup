
# Cumulus Setup

**What is Cumulus**? This is the virtual datacenter of [USPC (Universite Sorbonne Paris Cite)](http://uspc.fr). The dept of Economics has access to this resource.  

As is custom in many datacenters, you are provided with an **empty** computer. There is nothing but a operating system on it.  

These instructions aim at setting up your account and letting you connect to your VMs. The repository also contains several scripts which help installing your software.

## Getting an Account

* Write me an email explaining in 1 sentence why you need this service. This is more to understand whether it could be useful for you, rather than to restrict access to it. Access is granted exclusively to members of the Department of Economics at SciencesPo Paris.
* I'll send you an email with your password. 
* Go to [https://cumulus.parisdescartes.fr](https://cumulus.parisdescartes.fr)
	1. Click on your user name at the top of the page and then on `settings`.
	1. Click on `change password`. Change it.
	1. Click on `update SSH key`.
		* copy and paste your public SSH key(s) into the text field and click `update SSH key`.
		* You will be able to login without typing a password. Highly recommended.
		* To create your SSH key pair, follow [those instructions](https://help.github.com/articles/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent/#generating-a-new-ssh-key)
		* Type `cat ~/.ssh/id_rsa.pub` in your terminal to see your public key. copy and paste this to here.
	
## Creating new Virtual Machines (VM)

It is essential that you follow **each** of those steps:

1. Log in to [https://cumulus.parisdescartes.fr](https://cumulus.parisdescartes.fr)
1. Click on the green "+" button to add new VM
1. Choose a template for an OS. If you want to use my install script, choose Ubuntu 16.10 (on page 2)
1. Choose your preferred machine capacity
1. Choose a network interface. There is only one choice, but you need to click on it.
1. Give the VM a sensible, short name (both at top and bottom of this page). Josephine could call hers *jose-1* for example. no special signs please (like @ or ?!\|{} etc)
1. click on create

### Using a VM for the First Time 

* On your cumulus dashboard, you should see your running machine now. Click on the name of the VM to open it.
* Click on the little blue screen symbol to open a popup window with a console on that machine.
* login as `root`.
* you are prompted to choose a password. Do so.
* That's it. you are now the admin of that VM. You can install software and use it for your work.

## Connecting to the datacenter and your VM

* You can connect to your machines via SSH from your computer. You must have completed the above step beforehand.
* Your VM has an IP address under which is it reachable **from within the datacenter**.
* Your VM is **not** reachable directly from the internet.
* You must pass through the **login node** in order to reach your VM.
* The login node is behind port `2222` on our firewall to this datacenter.
* You can reach the login node by typing

```bash
ssh your_user_name@brome.lab.parisdescartes.fr -p 2222
```

* I need to give you `your_user_name` for this to work.
* Once you are on the login node, you need to connect to your VMs to start using them for your work.
* If your VM has IP `10.20.35.87`, you would now type `ssh root@10.20.35.87`
* Alternatively, if you gave it a name before, you could do `ssh root@jose-1`

### Hopping through the login node

**This part has only been tested for MacOS/Linux**. For windows you need to figure out yourself. Google *multihop ssh putty*.  

Our setup with firewall + login node is very common. There exists therefore a common strategy to make this less cumbersome. It is called *SSH hopping*, because we hop over the login node.

#### Prepare the server side

1. Create an SSH keypair for your user on the login node (see above)
1. copy the public part of that key to your VM: `scp id_rsa.pub 10.20.35.87:~`
1. You need to do that on each VM where you want to hop onto.
  
This command does that for you:

```
ssh-keygen -t rsa  # just hit enter, no password
cat ~/.ssh/id_rsa.pub | ssh root@10.20.35.87 'cat >> .ssh/authorized_keys'   # 10.20.35.87 is your VM
```


#### Prepare your side

you need to create or edit the file `~/.ssh/config`:

```bash
Host cumlogin
    User root
    Hostname brome.lab.parisdescartes.fr
    Port 2222
	PreferredAuthentications publickey
	IdentityFile ~/.ssh/id_rsa.pub

Host cumulus
	User root
	HostName xx.xx.xx.x  # IP of your VM!
	PreferredAuthentications publickey
	IdentityFile ~/.ssh/id_rsa.pub
	ProxyCommand ssh cum-login nc %h %p
```

Now if you do `ssh cumulus` on your computer it takes you directly to your compute node, hopping over the login:

```bash
➜  ~ ssh cumulus

**************************************************

                  W.E.L.C.O.M.E
               
                      on the
 
              ScPo Economics Login Node

            to CUMULUS at paris descartes

       Usage reserved to authorized users only.

* There is NO software installed on this node.
* You should ONLY use it to connect to your compute nodes.
* i.e. you now want to type `ssh your_user@IP-of-your-vm`
* questions: florian.oswald@sciencespo.fr


**************************************************
Welcome to Ubuntu 16.10 (GNU/Linux 4.8.0-41-generic x86_64)

 * Documentation:  https://help.ubuntu.com
 * Management:     https://landscape.canonical.com
 * Support:        https://ubuntu.com/advantage
New release '17.04' available.
Run 'do-release-upgrade' to upgrade to it.

Last login: Wed Apr 19 12:01:27 2017 from 10.20.35.2
root@vm2:~$ 
```

## Installing Software

1. `ssh` to your VM (**NOT** to the login node!!!!) by using the command:
	```bash
	ssh root@"IP_of_my_VM"
	```
	You will be asked to enter the password that you set up the first time you logged in as root (see the section "Using a VM for the First Time" above). 
1. To start installing software, enter the following lines in the terminal:
	```bash
	cd
	mkdir git
	cd git
	apt get install git
	git clone https://github.com/floswald/cumulus-setup.git 
	cd cumulus-setup
	./install.sh
	```
	You will be asked to enter 'Y' several times. When the installation is done, you can check that everything went fine by simply entering 'python' in the terminal.
