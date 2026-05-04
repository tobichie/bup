#!/usr/bin/env bash
# set -euo pipefail

# UPDATE:
# Make it so the absolute path can be used for the sourcefile 

# bup tool
# backup tool
# Tool for backing up files quickly 
# Description: Can backup files in directories on other networks hosts using smb 
# Author: Tyron Obichie
# Version: 1.0
# Usage: bup <source.txt> <192.168.10.194> <username> <password123> <share> <destination path>
version="1"
source="$1"
host="$2"
username="$3"
password="$4"
share="$5"
path="$6"

help() {
        printf "%s\n%s\n%s\n" "bup! The greatest backup tool to ever be made" "Example usage:" "bup <source.txt> <192.168.10.194> <username> <password123> <share> <destination path>"
        printf "%s\n%s\n%s\n%s\n%s\n%s\n" \
"There are Six options" \
"\$1 = Source File/Directory" \
"\$2 = destination host" \
"\$3 = username" \
"\$4 = password" \
"\$5 = destination share (e.g. homes)" \
"\$6 = path within the shared folder"
	printf "%s\n%s\n" "This scripts main purpose is to make it easier to backup files across the network, " "although it can be used to backup files to the localhost, doing so requires placeholders for the destination host, username, password, and destination share (can be anything)"
	printf "%s\n%s\n" "Syntax when backing up on localhost:" "bup <source.txt> <localhost/empty> <placeholder> <placeholder> <placeholder> <destination directory>"
}
# If smbclient isnt installed exit immediately
command -v smbclient >/dev/null 2>&1 || {
    echo "Error: smbclient is required"
    exit 1
}

# printf "%s\n" "Full path: $fullpath"
# ./bup.sh <source.txt> <192.168.10.194> <username> <password123> /<destination>
# printf "%s\n" "All variables: ${@}"
# if it's not localhost, the first will return false, triggering the second command, which activates $smb
# check if there are any arguments at all, if not show usage
if [[ "$1" = "-h" || "$1" = "--help" || "$#" -le 0 ]]; then
	help
else
if [ "$2" = "localhost" ] || [ -z "$2" ]; then smb=false && printf "%s\n" "Not using smb, using localhost"; else smb=true && printf "%s\n" "Using smb to connect "; fi
# if smb is false, cp the $source file to the $destination

# next up, check if the host is up, ping, grep 64 bytes. If the grep isnt empty, the host is up
# if $smb is false no network logic needed
if [ -n "$username" ]; then
	if [ "$smb" = false ]; then
		printf "%s\n" "no smb sadly"
		printf "%s\n" "Backing up file on localhost (Idiot Mode). Could've just used 'cp' yourself but ok."
		cp "$source" "$path"
		if [ "$?" -gt 0 ];then
			printf "%s\n" "Failed the Backup"
		else
			printf "%s\n" "Succeeded in Backing up like a dumpa truck" 
		fi
	else
		printf "%s\n" "Using smb"
		if ping -c 3 "$2" &>/dev/null; then
			printf "%s\n" "Host is online"
			# since the host is online we will be using the username and password provided to list the shares
			# smbclient "//$2/$share" -U "$username%$password" -c "cd /${share};ls;put ${source}"
			# smbclient "//$2/$share" -U "$username%$password" -c "cd \"$path\"; ls; put \"$source\""
			if [ -f "$source" ]; then
				smbclient "//$2/$share" -U "$username%$password" -c "cd \"$path\"; ls; put \"$source\""
			elif [ -d "$source" ]; then
				printf "%s\n" "Copying Directory into the destination"
				smbclient "//$host/$share" -U "$username%$password" <<EOF
lcd $(dirname "$source")
cd "$path"
recurse ON
prompt OFF
mput $(basename "$source")
EOF
			else
				# if it doesnt exist, create a file with the name $source and send it over using the smbclient command for files
				touch "$source"
				smbclient "//$2/$share" -U "$username%$password" -c "cd \"$path\"; ls; put \"$source\""
				printf "%s\n" "Created a new file with the name: ${source} in the directory: ${path}"
			fi

			if [ "$?" -ne 0 ]; then
				echo "Failed to backup the file"
			fi
		else
			printf "%s\n" "Host is offline"
		fi
	fi
else
	printf "%s\n" "You need to add a username"
	help
fi
fi
