
# install postgresql
apt-get --yes --forces-yes install \
      build-essential \
      postgis \
      postgresql \
      postgresql-client \
      postgresql-server-dev-9.5 \
      ruby

echo ""
echo "done with postgres"
echo "++++++++++++++++++"
echo ""


# setup postgres
passwd postgres   # choose a password for user postgres
# now alter yourself as superuser 
su - postgres
psql -c "alter user postgres with password 'postgres';"
createuser root --superuser
createdb root  
exit
