



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
