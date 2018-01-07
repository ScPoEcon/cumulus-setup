echo "++++++++++++++++++++++++++++++++++	"
echo "Installing julia v0.6 and packages"
echo "++++++++++++++++++++++++++++++++++	"
echo ""
# get julia v0.6
echo "Downloading"
wget https://julialang-s3.julialang.org/bin/linux/x64/0.6/julia-0.6.1-linux-x86_64.tar.gz
echo "Creating directory"
mkdir -p /apps/julia-0.6
echo "Unpacking"
tar -xzf julia-0.6.1-linux-x86_64.tar.gz -C /apps/julia-0.6 --strip-components 1
echo "Creating Symlink"
ln -sf /apps/julia-0.6/bin/julia $HOME/local/bin/julia 
echo "Cleaning"
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
				"PyPlot",
				"PyCall",
				"Calculus",
				"StatsFuns",
				"Dierckx",
				"DocOpt",
				"FactCheck",
				"ForwardDiff"]);
				Pkg.clone("https://github.com/floswald/ApproXD.jl");
				Pkg.clone("https://github.com/floswald/Copulas.jl");
				Pkg.clone("https://github.com/floswald/MOpt.jl");
				Pkg.clone("https://github.com/RJDennis/SmolyakApprox.jl");
				Pkg.clone("https://github.com/mrxiaohe/RobustStats.jl")
				' | \
	/apps/julia-0.6/bin/julia

echo ""
echo "done Installing julia"
echo "++++++++++++++++++"
echo ""

