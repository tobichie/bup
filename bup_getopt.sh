#!/usr/bin/env bash
# set -euo pipefail

# UPDATE:
# Make it so the absolute path can be used for the sourcefile 
# Prompt for the Password so it isnt shown in cleartext in the history
# just rebuild the whole thing with getopt you fucking idiot god damn

# bup tool
# backup tool
# Tool for backing up files quickly 
# Description: Can backup files in directories on other networks hosts using smb 
# Author: Tyron Obichie
# Version: 2.1
# Usage: bup <source.txt> <192.168.10.194> <username> <password123> <share> <destination path>

help() {
        printf "%s\n%s\n%s\n" "bup! The greatest backup tool to ever be made" "Example usage:" "bup <source.txt> <192.168.10.194> <username> <password123> <share> <destination path>"
        printf "%s\n%s\n%s\n%s\n%s\n%s\n" \
"There are Six options" \
"\$1 = Source File/Directory" \
"\$2 = destination host" \
"\$3 = username" \
"\$4 = destination share (e.g. homes)" \
"\$5 = path within the shared folder"
        printf "%s\n%s\n" "This scripts main purpose is to make it easier to backup files across the network, " "although it can be used to backup files to the localhost."
        printf "%s\n" "bup -s ./source.txt -H 192.168.10.101 -u admin -S homes -d User/destination"
}

printf "%s\n" "Running script: $0"
## -options help,verbose, source, host, username, share, destination path
## Parse options from commandline
OPTS=$(getopt -o hs:H:u:S:d: \
  --long help,source:,host:,username:,share:,destination: \
  -n "$0" -- "$@")
if [ "$?" -ne 0 ]; then
	echo "Failed to parse options" >&2
    help
	exit 1
fi
## eval set -- "$OPTS" changed the positional arguments to match the options ($1 becomes -h)
eval set -- "$OPTS"
## initialise variables
VERBOSE=false
source=""
host=""
username=""
share=""
destination=""

## If no opts and args -> help; exit 1


if [ "$#" -eq 1 ]; then
	help
	exit 1
fi
## Process the options

while true; do
    case "$1" in
        -h|--help)
            HELP=true
            shift
            ;;
        -s|--source)
            source="$2"
            echo "source is: $2"
            shift 2
            ;;
        
        -H|--host)
            host="$2"
            echo "host: $2"
            shift 2
            ;;
        
        -u|--username)
            username="$2"
            echo "username: $2"
            shift 2
            ;;
        
        -S|--share)
            share="$2"
            echo "the share is: $2"
            shift 2
            ;;
        
        -d|--destination)
            destination="$2"
            echo "destination: $2"
            shift 2
            ;;
        
        --)
            shift
            break
            ;;
        
        *)
            break
            ;;
    esac
done
# If help is used, show usage and exit immediately
if [[ -n "$HELP" ]]; then
	help
	exit 0
fi
# If smbclient isnt installed exit immediately
command -v smbclient >/dev/null 2>&1 || {
    echo "Error: smbclient is required"
    exit 1
}


if [ "$host" = "localhost" ] || [ -z "$host" ] || [ -n "$HELP" ]; then smb=false && printf "%s\n" "Not using smb, using localhost"; else smb=true && printf "%s\n" "Using smb to connect "; fi

if [[ -n "$username" || "$smb" = false ]]; then
        if [ "$smb" = false ]; then
                printf "%s\n" "Backing up file on localhost (Idiot Mode). Could've just used 'cp' yourself but ok."
                cp "$source" "$destination"
                if [ "$?" -gt 0 ];then
                        printf "%s\n" "Failed the Backup"
                else
                        printf "%s\n" "Succeeded in Backing up like a dumpa truck" 
                fi
        else
                if ping -c 3 "$host" &>/dev/null; then
                        printf "%s\n" "Host is online"
                        # smbclient "//$2/$share" -U "$username%$password" -c "cd /${share};ls;put ${source}"
                        # smbclient "//$2/$share" -U "$username%$password" -c "cd \"$path\"; ls; put \"$source\""
                        if [ -f "$source" ]; then
                                smbclient "//$host/$share" -U "$username" -c "cd \"$destination\"; ls; put \"$source\""
                        elif [ -d "$source" ]; then
                                printf "%s\n" "Copying Directory into the destination"
                                read -s -p "Password: " password
                                echo
                                smbclient "//$host/$share" -U "$username%$password" <<EOF
lcd "$(dirname "$source")"
cd "$destination"
recurse ON
prompt OFF
mput "$(basename "$source")"
EOF
                        else
                                # if it doesnt exist, create a file with the name $source and send it over using the smbclient command for files
                                touch "$source"
                                smbclient "//$host/$share" -U "$username" -c "cd \"$destination\"; ls; put \"$source\""
                                printf "%s\n" "Created a new file with the name: ${source} in the directory: ${destination}"
                        fi

                        if [ "$?" -ne 0 ]; then
                                echo "Failed to backup the file"
                        fi
                else
                        printf "%s\n" "Host is offline"
                fi
        fi
else
        echo $username
        printf "%s\n" "You need to add a username"
        help
fi

