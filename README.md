
# Cumulus Setup

**What is Cumulus**? This is the virtual datacenter of [USPC (Universite Sorbonne Paris Cite)](http://uspc.fr). The dept of Economics at ScPo has got access to this resource. The official help site is [here](https://cumulus.parisdescartes.fr/help/).

These instructions aim at setting up your account and letting you connect to your Virtual Machines (VMs). The repository also contains several scripts which help installing your software.

## Technical Specifications

You can choose machines of several sizes. The most powerful machine is

* Intel(R) Xeon(R) CPU E5-2690 v3 @ 2.60GHz
* 8 cores
* 8 GB ram  
* There is a very large amount of disk storage space available.
* Given that each VM has an IP address, you can build your own cluster (i.e. you can connect machines together to form a large number of workers in a master-worker setup)
* comment on **quota**

## Potential Uses of this system

Any kind of computation-heavy task, like:

* High throughput computing 
* Parallel computations
* Monte Carlo experiments
* Solving and estimating large structural models

This is not a very good system if you want to load a very large dataset into memory to perform analysis on it, given that you only get 8GB per machine.  


### Other potential systems for you

* [MAGI](https://magi.univ-paris13.fr). 184 core cluster, SLURM managed.
* [http://www.huma-num.fr](http://www.huma-num.fr). Storage and computation support. 
* [Amazon](https://aws.amazon.com). DIY.


## Types of Users

There are 2 possible ways to use this system:

1. **Power User**: you are able to manage your VM on your own, i.e. you are the *owner* of the VM. This means you have to install everything yourself. I will provide only minimal assistance to power users. 
2. **Normal User**: I create a user account on a VM for you and install all software in the script `install.sh` contained within this repository: 
	* I create a unix ubuntu 16 VM for you. 
	* I cannot guarantee any level of assistance. I will run the install script for you, but after that, you are on your own. sorry. :-(
	* If you want another OS (e.g. windows), you will have to declare yourself a power user, as I cannot provide any assistance with that.

**Related**: We probably want to avoid that each user has to create his/her own cluster. We will work with a very small cluster at the end of this tutorial.

### Available Software

As of now, I install for you:

* Gnu Compiler Collection (GCC)
* Julia 
* python
* R
* PostgreSQL  

In principle you can install anything you want. Notice that you will need an appropriate license for commercial software like `matlab` or `stata`. I will **not** provide assistance with installation of commercial software.


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

## First Things First: Unix, SSH, Users

* You can create windows machines. I will not talk about that, however.
* Some basic unix: 
	* What's a [shell](https://en.wikipedia.org/wiki/Unix_shell)? What is [bash](https://en.wikipedia.org/wiki/Bash_(Unix_shell)). What's a session, what are environment variables.
	* Remote connections. [SSH](https://en.wikipedia.org/wiki/Secure_Shell)
	* A typical user account on (Ubuntu) Unix
		* permissions: who can read, write, execute?
	
## Creating new Virtual Machines (VM)

It is essential that you follow **each** of those steps:

1. Log in to [https://cumulus.parisdescartes.fr](https://cumulus.parisdescartes.fr)
1. Click on the green "+" button to add new VM
1. Choose a template for an OS. If you want to use my install script, choose Ubuntu 16.10 (on page 2)
1. Choose your preferred machine capacity
1. Choose a network interface. There is only one choice, but you need to click on it.
1. Give the VM a sensible, short name (both at top and bottom of this page). Joe Bloggs would call his `joe_b` for example. 
1. click on create

## Power Users: Using a VM for the First Time 

This section only applies to **power users**.

* On your cumulus dashboard, you should see your running machine now. Click on the name of the VM to open it.
* Click on the little blue screen symbol to open a popup window with a console on that machine.
	* **Caution**: This console has an `AZERTY` (i.e. *French*) keyboard.
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
* If your VM has IP `10.20.35.87`, you would now type `ssh your_user@10.20.35.87`
* Joe could do `ssh joe@joe_b` (after I set up user `joe` on machine `joe_b` for him)

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
cat ~/.ssh/id_rsa.pub | ssh your_user@10.20.35.87 'cat >> .ssh/authorized_keys'   # 10.20.35.87 is your VM
```


#### Prepare your side

you need to create or edit the file `~/.ssh/config`:

```bash
Host cumlogin
    User your_user
    Hostname brome.lab.parisdescartes.fr
    Port 2222
	PreferredAuthentications publickey
	IdentityFile ~/.ssh/id_rsa.pub

Host cumulus
	User your_user
	HostName xx.xx.xx.x  # put IP of your VM and erase this comment!
	PreferredAuthentications publickey
	IdentityFile ~/.ssh/id_rsa.pub
	ProxyCommand ssh cumlogin nc %h %p
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

## Installing Software (power users only)

1. `ssh` to your VM (**NOT** to the login node!!!!) by using the command (if you have not set up the hopping as above)

	```bash
	ssh root@IP_of_my_VM
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
	You will be asked to enter `Y` (yes) several times. When the installation is done, you can check that everything went fine by simply entering `python`, or `R` in the terminal.


## Running Programs in Parallel

This is very software specific. Many languages rely on some external infrastructure to communicate between compute nodes, the best known is probably MPI (message passing interface). C, fortran and R can be parallelized with the help of `MPI`. However, this needs to be installed on all nodes (you need to do that yourself).  

A much easier system is used by julia. it uses passwordless SSH (like above!).  

### Parallel Julia on a single machine?

* I installed julia for you on `shared-master`
* launch it by typing `/shared/julia-0.5/bin/julia`
* you can then easily add processes by saying `addprocs(2)` for example
* however, how to connect multiple machines?


### Parallel Julia on multiple machines?

Prerequisites:  

1. We need the same version of julia installed (preferrably in the same location) on all machines.
1. We must be able to passwordless-SSH into each machine


