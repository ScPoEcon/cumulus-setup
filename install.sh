# ubuntu 16 install script on cumulus.parisdescartes.fr
# copyright 2017 florian.oswald@sciencespo.fr

# this script installs software 
# it needs to be run on your master node

# how to use:
# manually install git and clone this repo. execute those commands:

# apt-get update
# apt install git
# cd
# mkdir git
# cd git
# git clone git@github.com:floswald/cumulus-setup.git
# cd cumulus-setup
# ./install.sh

# you need to say yes (Y) a couple of times during the process

## Sequence of scripts:
# 1. install.sh
# 2. ssh.sh
# 3. nfs.sh


echo ""
echo "start of install script"
echo "+++++++++++++++++++++++"
echo ""
echo "This script will install recent versions of:"
echo "  - Gnu Compiler Collection (GCC)"
echo "  - R + packages"
echo "  - julia + packages"
echo ""
echo "It will prepare the installation of:"
echo "  - Pyenv (Python environment for multiple python versions"
echo "    you will have to finish installation by running a second"
echo "    script: python.sh"
echo ""
echo "Additional install scripts in this repo:"
echo "  - python.sh: installs python 2.7 and python 3.4"
echo "  - ssh.sh: setup passwordless ssh on a set of VMs"
echo "  - postgres.sh: install PostgreSQL"
echo "  - prompt.sh: install fancy git-aware shell "
echo ""
echo ""
echo "NOTICE:"
echo "you need to say yes (Y) a couple of times during the process"
echo ""
echo ""


# we want to share /root across all compute nodes.
# we will not sure any build tools on the compute nodes.
# only apps will be shared (only julia for now)
# can add more apps by manually building and placing into /apps here on the master
# to make sure this works, put the master's key in it's own authorized list:
# 1. ssh master && cat id_rsa.pub >> authorized_keys
# 

# 2. install stuff

sleep 4

echo ""
echo "First will setup your ~/.bashrc"
echo "+++++++++++++++++++++++"
echo ""
if [ $(id -u) -eq 0 ]; then
    echo 'if [ -n "$BASH_VERSION" ]; then 
        # include .bashrc if it exists 
        if [ -f "$HOME/.bashrc" ]; then 
            . "$HOME/.bashrc" 
        fi 
        fi' >> ~/.profile

    # echo "PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '" >> ~/.bashrc
    echo "alias ls='ls --color=auto'"  >> ~/.bashrc
fi

# setup a bin at user level
mkdir -p ~/local/bin
echo 'export PATH="$HOME/local/bin:$PATH"' >> ~/.bashrc

# get a nicer prompt
cat prompt.sh >> ~/.bashrc


sleep 3

apt-get update
apt install git
apt install htop
apt-get install hdf5-tools
# compilers	
apt install gcc
apt install python
apt-get install autojump


echo 'if [ "$(hostname)" == "master" ]; then
   . /usr/share/autojump/autojump.sh
fi' >> ~/.bashrc

echo ""
echo "done installing GCC"
echo "++++++++++++++++++"
echo ""

sleep 2

apt install python
apt-get install autojump
echo ". /usr/share/autojump/autojump.sh" >> ~/.bashrc


echo ""
echo "Installing R"
echo "++++++++++++++++++"
echo ""
# install R
echo "deb http://cran.rstudio.com/bin/linux/ubuntu yakkety/" | \
    tee -a /etc/apt/sources.list
apt-get install r-base
# install R packages
echo 'requirements = c("ggplot2",
                         "data.table",
                         "Rcpp",
                         "RcppArmadillo",
                         "RcppGSL",
                         "reshape2",
                         "animation",
                         "rjson",
                         "xtable",
                         "devtools",
                         "texreg",
                         "testthat",
                         "gridR",
                         "psidR",
                         "RPostgreSQL",
                         "sf",
                         "rgdal",
                         "sp",
                         "DBI"
                         )

        sapply(requirements,
               function(x) {
                    if (!x %in% installed.packages()[,"Package"])
                        install.packages(x, repos="http://cran.r-project.org")})' | \
  R --no-save

echo ""
echo "done Installing R"
echo "++++++++++++++++++"
echo ""

sleep 3


echo ""
echo "Installing julia and packages"
echo "+++++++++++++++++++++++++++++"
echo ""
# get julia
wget https://julialang.s3.amazonaws.com/bin/linux/x64/0.5/julia-0.5.1-linux-x86_64.tar.gz
mkdir -p /apps/julia-0.5
tar -xzf julia-0.5.1-linux-x86_64.tar.gz -C /apps/julia-0.5 --strip-components 1
ln -s /apps/julia-0.5/bin/julia $HOME/local/bin/julia 
rm julia-0.5.1-linux-x86_64.tar.gz
echo 'ENV["PYTHON"]=""; Pkg.add.(["JSON",
                "FileIO",
                "DataFrames",
                "BenchmarkTools",
                "RData",
                "Interpolations",
                "Yeppp",
                "DataFramesMeta",
                "FreqTables",
                "FixedSizeArrays",
                "Plots",
                "RCall",
                "Logging",
				"GLM",
				"PDMats",
				"Distributions",
				"Optim",
				"HDF5",
				"JLD",
				"JSON",
				"JuMP",
				"Ipopt",
				"NLsolve",
				"NLopt",
				"ClusterManagers",
				"PyPlot",
				"Query",
                "DocOpt"]);
				Pkg.clone("https://github.com/floswald/ApproXD.jl");
				Pkg.clone("https://github.com/floswald/Copulas.jl");
				Pkg.clone("https://github.com/floswald/MOpt.jl")' | \
	/apps/julia-0.5/bin/julia

echo ""
echo "done Installing julia"
echo "++++++++++++++++++"
echo ""

sleep 3

echo "Done installing!"
echo "========================"

sleep 2

echo "Now we setup the file sharing"
echo "============================="



