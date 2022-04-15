#! /usr/bin/env bash

USER_UID=$(grep $USER /etc/passwd |awk -F':' '{print $3}')


echo "UID: $USER_UID"
echo "Username: $USER"

if [ "$USER_UID" -eq 0 ]
then
  echo "User is root"
else
  echo "User is not root"
fi
