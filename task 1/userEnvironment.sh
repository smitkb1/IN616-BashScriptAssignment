#!/bin/bash

file=$1

#This checks if a CSV file was input as a command line argument, if not it will ask the user to pick one"
if [[ ! -f $1 || -z $1 ]]
then
echo "Which CSV file would you like to read?"
read file
fi

if [[ -f $file ]]
then

entryCount=`cat $file | wc -l`
((entryCount--))
echo "$entryCount users will be added"

IFS=";"
i=0
while read col1 col2 col3 col4
do

if [[ "$i" -ge "1" ]]
then  
firstname=`echo "$col1" | grep -oP '^[a-z]' `
lastname=`echo "$col1" | grep -oP '(?<=\.)(.*?)(?=\@)'`
username=${firstname}${lastname}
password=`date -d "$col2" +'%m%Y'`
group=`echo "$col3" | grep -oP '^\w+' `
sharedFolder=$col4

if [[ ! -d "$sharedFolder" ]]
then
sudo mkdir /home/IN616-BashScriptAssignment/"task 1"/"$sharedFolder"
fi
sudo groupadd "$group"

if [[ $? == 0 ]]
then
sudo chgrp -R "$group" /home/IN616-BashScriptAssignment/"task 1"/"$sharedFolder"
sudo chmod -R 2775 /home/IN616-BashScriptAssignment/"task 1"/"$sharedFolder"
fi

sudo useradd -d /home/"$username" -m -s /bin/bash "$username"
echo "$username"
echo "$password"
echo "$group"
echo "$col4"
fi
((i++))
done<$file 
else
echo "<<< Error: File does not exist. Exiting... >>>"
fi
