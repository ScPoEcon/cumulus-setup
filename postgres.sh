# setup postgres
passwd postgres   # choose a password for user postgres
# now alter yourself as superuser 
su - postgres
psql -c "alter user postgres with password 'postgres';"
createuser root --superuser
createdb root  
exit
