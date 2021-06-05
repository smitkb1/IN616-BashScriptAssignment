#!/bin/bash

file=$1

#This checks if a CSV file was input as a command line argument, if not it will ask the user to pick one
#If the user entered a command line argument that wasn't a file, the script will ask as well to give them
#another chance to get it right before exiting the script.
if [[ ! -f $1 || -z $1 ]]
then
echo "Which CSV file would you like to read?"
read file
fi

#If the file variable is filled by a file then the script will run otherwise it will exit
if [[ -f $file ]]
then

#entryCount counts the amount of lines in the csv file and then decrements by 1 to output the number of 
#users being created as the first line is the column headings and not a user entry
entryCount=`cat $file | wc -l`
((entryCount--))
echo "$entryCount users will be added"

IFS=";"
i=0
while read col1 col2 col3 col4
do

#this checks if i is 1 or more and will only run this part of the script if it is. This was to stop the script
#from trying to create a user from the column headings.
if [[ "$i" -ge "1" ]]
then  
firstname=`echo "$col1" | grep -oP '^[a-z]' `
lastname=`echo "$col1" | grep -oP '(?<=\.)(.*?)(?=\@)'`
#I couldn't figure out how to regex the first initial and the last name on one line so I made two seperate variables
#and concatenated them into a single variable. 
username=${firstname}${lastname}
password=`date -d "$col2" +'%m%Y'`
group=`echo "$col3" | grep -oP '^\w+' `
sharedFolder=$col4

#if shared folder isn't a directory it will be created
if [[ ! -d "$sharedFolder" ]]
then
sudo mkdir /home/IN616-BashScriptAssignment/"task 1""$sharedFolder"
fi
#groupadd will tell you if the group has already been created and won't make a duplicate so I left it as is
sudo groupadd "$group"

#if group is created successfully then the following code will execute. If the group isn't created succesfully there
#is no need to change the group permissions
if [[ $? == 0 ]]
then
sudo chgrp -R "$group" /home/IN616-BashScriptAssignment/"task 1""$sharedFolder"
sudo chmod -R 2775 /home/IN616-BashScriptAssignment/"task 1""$sharedFolder"
fi

#create user
sudo useradd -d /home/"$username" -m -s /bin/bash "$username"
echo "$username:$password" | sudo chpasswd

#create a softlink and move it to the user's folder
ln -s /home/IN616-BashScriptAssignment/"task 1""$sharedFolder" shared
sudo mv /home/IN616-BashScriptAssignment/"task 1"/shared /home/"$username"/

#append user to any secondary groups 
sudo usermod -a -G "$col3" "$username"
echo "$username"
echo "$password"
echo "$group"
echo "$col4"
fi
#i increment so the code doesn't try make a user for the column headings
((i++))
done<$file 
else
echo "<<< Error: File does not exist. Exiting... >>>"
fi
