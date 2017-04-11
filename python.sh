


declare -a workers=(vm3-8core vm4-8core vm5-8core vm6-8core)
for i in "${workers[@]}"
do
	echo "install on worker $i"
	scp install.sh "$i":~
	ssh $i 'chmod 755 ~/install.sh'
	ssh $i './install.sh'
	ssh $i 'rm ./install.sh'
	echo "done installing on worker $i"
done


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
