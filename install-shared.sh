# ubuntu 16 install script on cumulus.parisdescartes.fr
# copyright 2017 florian.oswald@sciencespo.fr

# this script installs software on a shared VM

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


echo ""
echo "start of install script"
echo "+++++++++++++++++++++++"
echo ""
echo "This script will install recent versions of:"
echo "  - Gnu Compiler Collection (GCC)"
echo "  - R + packages"
echo "  - julia + packages"
echo "  - python 2.7"
echo ""

sleep 3

apt-get update
apt install git
# compilers	
apt install gcc

echo ""
echo "done installing GCC"
echo "++++++++++++++++++"
echo ""

sleep 2


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
cd
wget https://julialang.s3.amazonaws.com/bin/linux/x64/0.5/julia-0.5.1-linux-x86_64.tar.gz
mkdir -p /apps/julia-0.5
tar -xzf julia-0.5.1-linux-x86_64.tar.gz -C /apps/julia-0.5 --strip-components 1
ln -s /apps/julia-0.5/bin/julia /root/local/bin/julia 
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
	julia

echo ""
echo "done Installing julia"
echo "++++++++++++++++++"
echo ""





