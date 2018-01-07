# get julia v0.6
wget https://julialang-s3.julialang.org/bin/linux/x64/0.6/julia-0.6.1-linux-x86_64.tar.gz
mkdir -p /apps/julia-0.6
tar -xzf julia-0.6.1-linux-x86_64.tar.gz -C /apps/julia-0.6 --strip-components 1
#ln -sf /apps/julia-0.6/bin/julia $HOME/local/bin/julia 
ln -sf /apps/julia-0.6/bin/julia /usr/bin/julia 
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
				"GaussianMixtures",
				"DocOpt"]);
				Pkg.clone("https://github.com/floswald/ApproXD.jl");
				Pkg.clone("https://github.com/floswald/Copulas.jl");
				Pkg.clone("https://github.com/floswald/MOpt.jl")' | \
	/apps/julia-0.6/bin/julia

echo ""
echo "done Installing julia"
echo "++++++++++++++++++"
echo ""

