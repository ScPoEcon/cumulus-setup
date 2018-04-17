# ubuntu 16 install script on cumulus.parisdescartes.fr
# copyright 2018 florian.oswald@sciencespo.fr

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


# important: you need to create a proper unix user (NOT ROOT!)
# first. 


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


sleep 4

echo ""
echo "create user"
echo "+++++++++++++++++++++++"
echo ""

sleep 3

sudo apt-get update
sudo apt-get install --yes git
sudo apt-get install --yes htop
sudo apt-get install --yes hdf5-tools
# compilers	
sudo apt-get install --yes build-essential 
sudo apt-get install --yes gcc
echo ""
echo "done installing GCC"
echo "++++++++++++++++++"
echo ""
sudo apt-get install --yes gfortran

sudo apt-get install --yes python
sudo apt-get install --yes autojump

echo ". /usr/share/autojump/autojump.sh" >> ~/.bashrc


echo ""
echo "Installing R"
echo "++++++++++++++++++"
echo ""

# ubuntu package installation  for R
echo "deb http://cran.rstudio.com/bin/linux/ubuntu xenial/" | \
    tee -a /etc/apt-get/sources.list

sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E084DAB9
gpg --keyserver keyserver.ubuntu.com --recv-key E084DAB9
gpg -a --export E084DAB9 | sudo apt-key add -

# ubuntu requirements for R packages
sudo apt-get install --yes r-base r-base-dev
sudo apt-get install --yes libssl-dev
sudo apt-get install --yes libpq-dev
sudo apt-get install --yes libgsl-dev
sudo apt-get install --yes libgdal1-dev libproj-dev libgeos-dev
sudo apt-get install --yes libudunits2-dev
sudo apt-get install --yes software-properties-common python-software-properties
sudo add-apt-repository -y ppa:ubuntugis/ubuntugis-unstable
sudo apt update 
sudo apt upgrade # if you already have gdal 1.11 installed 

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
                         "copula",
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
cd
wget https://julialang-s3.julialang.org/bin/linux/x64/0.6/julia-0.6.2-linux-x86_64.tar.gz
mkdir -p ~/apps/julia-0.6
tar -xzf julia-0.6.2-linux-x86_64.tar.gz -C ~/apps/julia-0.6 --strip-components 1
rm julia-0.6.2-linux-x86_64.tar.gz
echo 'Pkg.add.(["JSON",
                "FileIO",
                "DataFrames",
                "BenchmarkTools",
                "RData",
                "Interpolations",
                "Yeppp",
                "DataFramesMeta",
                "FreqTables",
                "StaticArrays",
                "PGFPlots",
                "Plots",
                "StatPlots",
                "ProgressMeter",
                "RCall",
                "Logging",
				"GLM",
				"PDMats",
				"Distributions",
				"Optim",
				"JLD2",
				"JuMP",
				"Ipopt",
				"NLsolve",
				"NLopt",
				"ClusterManagers",
				"GR",
				"Query",
                "DocOpt"]);
				Pkg.clone("https://github.com/floswald/ApproXD.jl");
				Pkg.clone("https://github.com/floswald/MomentOpt.jl")' | \
	~/apps/julia-0.6/bin/julia --color=yes

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



