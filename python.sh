



echo ""
echo "Preparing Installing Pyenv"
echo "++++++++++++++++++"
echo ""
apt-get --yes install -y make build-essential libssl-dev zlib1g-dev libbz2-dev \
libreadline-dev libsqlite3-dev wget curl llvm libncurses5-dev libncursesw5-dev \
xz-utils tk-dev
git clone https://github.com/pyenv/pyenv.git ~/.pyenv
echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ~/.bashrc
echo 'export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.bashrc
echo 'eval "$(pyenv init -)"' >> ~/.bashrc
# for lxml library
apt-get --yes --force-yes install libxml2-dev libxslt1-dev

echo "starting a new shell now!"

exec $SHELL

sleep 3

echo ""
echo "Installing Python 2.7.8"
echo "========================"
echo ""
pyenv install 2.7.8

sleep 3
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
