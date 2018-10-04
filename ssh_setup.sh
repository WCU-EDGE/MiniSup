#!/bin/bash
ssh-keyscan -H 192.168.1.1 >> ~/.ssh/known_hosts
ssh 192.168.1.1 -f 'sleep 5'
ssh-keyscan -H 192.168.1.2 >> ~/.ssh/known_hosts
ssh 192.168.1.2 -f 'sleep 5'
ssh-keyscan -H 192.168.1.3 >> ~/.ssh/known_hosts
ssh 192.168.1.3 -f 'sleep 5'
ssh-keyscan -H 192.168.1.4 >> ~/.ssh/known_hosts
ssh 192.168.1.4 -f 'sleep 5'
ssh-keyscan -H 192.168.1.5 >> ~/.ssh/known_hosts
ssh 192.168.1.5 -f 'sleep 5'
ssh-keyscan -H 192.168.1.6 >> ~/.ssh/known_hosts
ssh 192.168.1.6 -f 'sleep 5'
