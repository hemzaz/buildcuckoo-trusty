#! /bin/sh
cd /data/moloch/viewer
echo "please enter username :" read user
echo "please enter password :" read pass
node addUser.js user "user" pass
cd ..
