# this script launches the building process on your master node

# I have cumulus as a host name in my ~/.ssh/config

scp install.sh cumulus:~   # copy this to cumulus
ssh cumulus 'chmod 755 install.sh'   # allow execution of the script
ssh cumulus './install.sh'   # execution the script

