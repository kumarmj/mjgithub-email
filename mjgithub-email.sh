#!/usr/bin/env bash
# Author: Manoj Kumar
# Reources- http://www.grymoire.com/Unix/Sed.html#uh-4
# Based on- https://github.com/owsmmj/github-email/blob/master/github-email.sh

if [ $# -eq 0 ] 
then
	printf "Username: "
	read user
else
	user="$1"
fi

email="$(curl "https://api.github.com/users/$user" -s \
    | sed -nE 's#^.*"email": "(.+)",.*$#\1#p')"

if [ ${#email} -eq 0 ]
then
	repo="$(curl "https://api.github.com/users/$user/repos?type=owner&sort=updated" -s \
        | sed -nE 's#^.*"name": "([^"]+)",.*$#\1#p' \
        | head -n1)"

    curl "https://api.github.com/repos/$user/$repo/commits" -s \
		| sed -nE 's#^.*"(email|name)": "([^"]+)",.*$#\2#p'  \
		| pr -2 -at \
		| sort -u
else
	echo $email
fi

#############################################################################################
# sed - special editor for modifying files													#
# "-n" option will not print anything unless explicit request								#
# "-E" Extended Regular expression enables '+', '*'											#
# 's# pattern1 # pattern2 #p'																#
# When the "-n" option is used, the "p" flag will cause the modified line to be printed.	#
# head -n1: outputs first line of input from head											#
# pr -2 -at: 'pr'- print 'a' means across '-2' columns	-t 'Do not print title'				#
# sort -u: sort unique entries only															#
#############################################################################################