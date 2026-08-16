# bup

## Name
bup! The greatest backup tool to ever be made!

## Description
Long Options: \help, source, host, username, share, destination path\
Short Options: hs:H:u:S:d: \
This scripts main purpose is to make it easier to backup files across the network, 
It can be used to backup files to the localhost by omitting the hostname or using the argument 'localhost' but at that point
you might aswell just use the copy command 'cp'.

## Installation

No Windows support.
Download the script on the git website or git clone it to a local directory.
Make it executable:
chmod +x bup.sh
chmod 744 bup.sh
If you want to be able to use it like other commands (from anywhere and without the file extension), move it into a bin.
Find your bins by using "echo $PATH", then use the mv (move) command to move it there. 
To remove the file extension just move it into the bin without it or change the name entirely to something less bad.
----------

git clone https://git.ide3.de/tyobi/bup\
chmod +x ./bup.sh\
mv ./bup.sh /usr/bin/bup // /usr/bin is a standard binary/executable directory \
bup # Will show usage\

----------
## Usage

Options:\
-s/--source: The directory/file that is being backed up.\
-H/--host: The hostname (can be a remote host, localhost or empty).\
-u/--username: The username required to login to the smbserver.\
-S/--share: The share containing the destination Path.\
-d/--destination: The destination path on the remote/local host.\

# Example Usage\

bup -s/--source <source dir/file> -H/--host <hostname> -u/--username <username> -S/--share <share> -d/--destination <destination path>\
bup -s ./source.txt -H 192.168.10.101 -u admin -S homes -d User/destination\

## Support\

Contact me if you can find me. Otherwise tough luck buddy.\

## Contributing\

Open to contributions if you can find and message me.\

## Project status\

Pretty much done, it works the way I want it to but if someone finds me and recommends someting it might get added.\
Unless they find me in the shower in which case what the hell man get out.\
Oh and add options to have the backup run at certain times by using cron!\
