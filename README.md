# Install

```
git clone https://github.com/MatthewCroughan/ntfscopy.git
cd ntfscopy
./install.sh
```

# Usage

```
Usage: ntfscopy [COMMAND]... OR [DISKNAME]... OR [OPTION]... ARGUMENT
Examples:
    ntfscopy sda1
    ntfscopy monitor
    ntfscopy -d /home/pi/files
Commands:
    monitor                               Tail the output of the ntfscopy log
    monitor verbose                       A more verbose version of monitor
Options:
    -d                                    Specify the directory containing files with which to copy over with rsync
```

Set the *absolute* path of the directory containing the contents you want via `ntfscopy.sh -d [directory]`

`home/pi` is a relative directory and will not work.

`~/home/pi` is also a relative directory and will not work.

`/home/pi/downloads/copyfiles/` is an absolute directory and will work.

`ntfscopy.sh monitor` will monitor what is going on

`ntfscopy.sh monitor verbose` will monitor what is going on in more detail.

