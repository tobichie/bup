# bup

## Name

**bup! The greatest backup tool to ever be made!**

## Description

Long options: `--help`, `--source`, `--host`, `--username`, `--share`, `--destination`

Short options: `-h`, `-s`, `-H`, `-u`, `-S`, `-d`

This script's main purpose is to make it easier to fully back up files across the network.

It can be used to back up files to the localhost by omitting the hostname or using the argument `localhost`, but at that point you might as well just use the `cp` command.

## Installation

No Windows support.

Download the script from the Git website or clone it to a local directory:

```bash
git clone https://git.ide3.de/tyobi/bup
```

Make it executable:

```bash
chmod +x ./bup.sh
chmod 744 ./bup.sh
```

If you want to be able to use it like other commands (from anywhere and without the file extension), move it into a directory contained in your `$PATH`.

Find your binary directories with:

```bash
echo $PATH
```

Then move and rename the script:

```bash
mv ./bup.sh /usr/bin/bup
```

`/usr/bin` is a standard directory for executable programs.

You can then run:

```bash
bup
```

This will show the usage information.

## Usage

Options:

* `-s`, `--source`: The directory/file that is being backed up.
* `-H`, `--host`: The hostname (can be a remote host, `localhost`, or empty).
* `-u`, `--username`: The username required to log in to the SMB server.
* `-S`, `--share`: The share containing the destination path.
* `-d`, `--destination`: The destination path on the remote/local host.

### Example Usage

```bash
bup -s/--source <source dir/file> -H/--host <hostname> -u/--username <username> -S/--share <share> -d/--destination <destination path>
```

For example:

```bash
bup -s ./source.txt -H 192.168.10.101 -u admin -S homes -d User/destination
```

## Support

Contact me if you can find me. Otherwise, tough luck buddy.

## Contributing

Open to contributions if you can find and message me.

## Project Status

Pretty much done. It works the way I want it to, but if someone finds me and recommends something, it might get added.

Unless they find me in the shower, in which case, what the hell, man? Get out.

Oh, and add options to have the backup run at certain times by using `cron`!
