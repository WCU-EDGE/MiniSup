#!/bin/bash

echo "createUserDirs.sh"

USERNAMELIST=$(getent passwd {1000..60000} | sed 's/:.*//')

set -x

# Create a directory for every user.
for u in $USERNAMELIST 
do
    if [ ! -d /scratch/$u ]; then
       # Whoever gets to this code first does the work.
       sudo mkdir /scratch/$u
        
       # Copy the source files from the repository, if they exist.
       sudo cp -R /local/repository/source/* /scratch/$u || true
       sudo chmod -R 755 /scratch/$u/*
    
       # Give ownership to the user
       sudo chown -hR $u /scratch/$u
    fi
done
