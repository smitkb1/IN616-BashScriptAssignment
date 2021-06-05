#!/bin/bash

#This enables the script to accept the directory as a command line argument
directory=$1

#If no command line argument is given, the script will ask the user for a directory and read it.

#It will also ask the user for a directory if the user's command line argument wasn't a directory
#as this gives them another chance to get the directory right before they are booted from the script.
if [[ ! -d $1 || -z $1 ]]
then
echo "Enter a directory you wish to archive (example: /home/student)"
read directory
fi

#
if [ -d $directory ]
then
basename "$directory"
tarname="$(basename -- $directory)"
#Create a backup of the selected directory
sudo tar -czf /tmp/$tarname.tar.gz  $directory . 2> /dev/null
echo $?
#Add error checking to make sure the tar command was succesful
if [[ $? == 0 ]]
then 
echo "<<< Backup archive was successfully created >>>"
echo "$tarname.tar.gz"
echo "Enter the IP address of the remote server you wish to upload your archive to"
read IP
echo "Enter the port number of the remote server you wish to upload your archive to"
read port
echo "Enter the directory of the remote server you wish to upload your archive to"
read remotedirect
scp -P $port /tmp/$tarname.tar.gz student@$IP:"$remotedirect"
if [[ $? == 0 ]]
then
echo "<<< Archive successfully backed up to remote server! >>>"
else
echo "Error! Remote server information incorrect! Exiting..."
exit 1
fi 
else
echo "Backup failed. Exiting..."
exit 1
fi
else
echo "Directory does not exist! Exiting..."
exit 1
fi
