# ubuntu 16 install script on cumulus.parisdescartes.fr
# copyright 2017 florian.oswald@sciencespo.fr

# this script installs software 
# it needs to be run on your master node

# how to use:
# manually install git and clone this repo. execute those commands:

# apt-get update
# apt-get install --yes git
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
echo "I am saying yes (Y) a couple of times for you during the process"
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
apt-get install --yes git
apt-get install --yes htop
apt-get install --yes hdf5-tools
# compilers	
apt-get install --yes build-essential 
apt-get install --yes gcc
echo ""
echo "done installing GCC"
echo "++++++++++++++++++"
echo ""
apt-get install --yes gfortran

apt-get install --yes python
apt-get install --yes autojump

sleep 2

apt-get install --yes python
apt-get install --yes autojump
echo ". /usr/share/autojump/autojump.sh" >> ~/.bashrc


echo ""
echo "Installing R"
echo "++++++++++++++++++"
echo ""
# install R to custom location - better to manage modules environment at some point
# apt-get install --yes libreadline6 libreadline6-dev
# apt-get install --yes zlib1g-dev
# apt-get install --yes bzip2
# apt-get install --yes lbzip2
# wget https://cran.rstudio.com/src/base/R-3/R-3.4.0.tar.gz
# mkdir -p /apps/R-3.4
# tar -xzf R-3.4.0.tar.gz 
# cd R-3.4.0
# ./configure --prefix=/apps/R-3.4 --enable-R-shlib -with-x=no
# make && make install
# echo 'export PATH="/apps/R-3.4/bin:$PATH"' >> ~/.bashrc

# ubuntu package installation  for R
echo "deb http://cran.rstudio.com/bin/linux/ubuntu yakkety/" | \
    tee -a /etc/apt/sources.list
apt-get install --yes r-base
apt-get install --yes libssl-dev

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
echo "Installing julia v0.6 and packages"
echo "++++++++++++++++++++++++++++++++++	"
echo ""
# get julia v0.5
#wget https://julialang.s3.amazonaws.com/bin/linux/x64/0.5/julia-0.5.1-linux-x86_64.tar.gz
#mkdir -p /apps/julia-0.5
#tar -xzf julia-0.5.1-linux-x86_64.tar.gz -C /apps/julia-0.5 --strip-components 1
#ln -s /apps/julia-0.5/bin/julia $HOME/local/bin/julia 
#rm julia-0.5.1-linux-x86_64.tar.gz
# get julia v0.6
wget https://julialang-s3.julialang.org/bin/linux/x64/0.6/julia-0.6.1-linux-x86_64.tar.gz
mkdir -p /apps/julia-0.6
tar -xzf julia-0.6.1-linux-x86_64.tar.gz -C /apps/julia-0.6 --strip-components 1
ln -sf /apps/julia-0.6/bin/julia $HOME/local/bin/julia 
rm julia-0.6.1-linux-x86_64.tar.gz


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
				"CompEcon",
				"QuantEcon",
				"ApproxFun",
				"Plots",
				"PyCall",
				"Calculus",
				"StatsFuns",
				"Dierckx",
				"DocOpt",
				"FactCheck",
				"ForwardDiff"]);
				Pkg.clone("https://github.com/floswald/ApproXD.jl");
				Pkg.clone("https://github.com/floswald/Copulas.jl");
				Pkg.clone("https://github.com/floswald/MomentOpt.jl");
				Pkg.clone("https://github.com/RJDennis/SmolyakApprox.jl");
				Pkg.clone("https://github.com/mrxiaohe/RobustStats.jl")
				' | \
	/apps/julia-0.6/bin/julia

echo ""
echo "done Installing julia"
echo "++++++++++++++++++"
echo ""

sleep 3

echo ""
echo "Getting PyPlot ready"
echo "+++++++++++++++++++++"
echo ""

sudo apt install python-pip
export LC_ALL=C
pip install --user matplotlib

#necessary if running this script as sudo
cd 
sudo chown -R $USER .julia


echo 'ENV["PYTHON"]=""; Pkg.build("PyCall")' | \
	/apps/julia-0.6/bin/julia

alias julia="$HOME/local/bin/julia"

echo "Done installing!"
echo "========================"

sleep 2

echo "Now we setup the file sharing"
echo "============================="



