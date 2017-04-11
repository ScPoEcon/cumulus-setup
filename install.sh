# ubuntu 16 install script on cumulus.parisdescartes.fr
# copyright 2017 florian.oswald@sciencespo.fr

# this script installs software 
# it needs to be run on each newly created virtual machine.

# how to use:
# scp install.sh cumulus:~   # copy this to cumulus
# ssh cumulus 'chmod 755 install.sh'   # allow execution of the script
# ssh cumulus './install.sh'   # execution the script
# you need to say yes (Y) a couple of times

# we are always root on this system, so no sudo required
# you need to first manually install git:

echo ""
echo "start of install script"
echo "+++++++++++++++++++++++"
echo ""


echo ""
echo "First will setup your .bashrc"
echo "+++++++++++++++++++++++"
echo ""
echo 'if [ -n "$BASH_VERSION" ]; then 
    # include .bashrc if it exists 
    if [ -f "$HOME/.bashrc" ]; then 
        . "$HOME/.bashrc" 
    fi 
    fi' >> ~/.profile

echo "PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '" >> ~/.bashrc
cat prompt.sh >> ~/.bashrc
echo "alias ls='ls --color=auto'"  >> ~/.bashrc

echo "adding ~/local to your PATH"
mkdir -p $HOME/local/bin
echo 'export PATH="$HOME/local/bin:$PATH"' >> ~/.bashrc
exec $SHELL


apt-get update
apt install git
# compilers	
apt install gcc

# install postgresql
apt-get install \
      build-essential \
      postgis \
      postgresql \
      postgresql-client \
      postgresql-server-dev-9.5 \
      ruby

# setup postgres
passwd postgres   # choose a password for user postgres
# now alter yourself as superuser 
su - postgres
psql -c "alter user postgres with password 'postgres';"
createuser root --superuser
createdb root  
exit

echo ""
echo "done with postgres"
echo "++++++++++++++++++"
echo ""

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

echo ""
echo "Installing julia and packages"
echo "+++++++++++++++++++++++++++++"
echo ""
# get julia
wget https://julialang.s3.amazonaws.com/bin/linux/x64/0.5/julia-0.5.1-linux-x86_64.tar.gz
mkdir -p apps/julia-0.5
tar -xzf julia-0.5.1-linux-x86_64.tar.gz -C apps/julia-0.5 --strip-components 1
ln -s /root/apps/julia-0.5/bin/julia /root/local/bin/julia 
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
				"Query"]);
				Pkg.clone("https://github.com/floswald/ApproXD.jl");
				Pkg.clone("https://github.com/floswald/Copulas.jl");
				Pkg.clone("https://github.com/floswald/MOpt.jl")' | \
	julia

echo ""
echo "done Installing julia"
echo "++++++++++++++++++"
echo ""

echo ""
echo "Installing Pyenv"
echo "++++++++++++++++++"
echo ""
apt-get install -y make build-essential libssl-dev zlib1g-dev libbz2-dev \
libreadline-dev libsqlite3-dev wget curl llvm libncurses5-dev libncursesw5-dev \
xz-utils tk-dev
git clone https://github.com/pyenv/pyenv.git ~/.pyenv
echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ~/.bashrc
echo 'export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.bashrc
echo 'eval "$(pyenv init -)"' >> ~/.bashrc
# for lxml library
apt-get install libxml2-dev libxslt1-dev
exec $SHELL
echo ""
echo "Installing Python 2.7.8"
echo "========================"
echo ""
pyenv install 2.7.8
echo ""
echo "Installing Python 3.4.0 and packages"
echo "===================================="
echo ""
pyenv install 3.4.0
pyenv shell 3.4.0
pip install argparse requests lxml psycopg2 configparser cython\
    numpy sqlalchemy folium bs4
echo ""
echo "Done Installing Pyenv"
echo "++++++++++++++++++"
echo ""




