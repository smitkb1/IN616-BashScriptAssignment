#!/bin/bash

file=$1

if [[ ! -f $1 || -z $1 ]]
then
echo "Which CSV file would you like to read?"
read file
fi

if [[ -f $file ]]
then

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
sharedFolder=$col4

if [[! -d "$sharedFolder" ]]
then
sudo mkdir


echo "$username"
echo "$password"
echo "$col3"
echo "$col4"
fi
((i++))
done<$file 
else
echo "<<< Error: File does not exist. Exiting... >>>"
fi
