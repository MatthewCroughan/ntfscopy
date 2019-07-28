# Install

```
git clone https://github.com/MatthewCroughan/ntfscopy.git
cd ntfscopy
./install.sh
```

If you wish to change the notification sound that is used, simply replace the file `sounds/notification.wav` in this repo and run `./install.sh` again

# Update

Updating or changing aspects of the prgoram can be done by running `install.sh` again.

```
git pull
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
    start                                 Create the udev rule to start processing disks upon plugin
    stop                                  Remove the udev rule, halting any processing of disks upon plug in
Options:
    -d                                    Specify the directory containing files with which to copy over with rsync
    -r                                    Reset the activity LED on the Pi
```

Set the *absolute* path of the directory containing the contents you want via `ntfscopy.sh -d [directory]`

✖ `home/pi` is a relative directory and is **invalid**

✖ `~/home/pi` is also a relative directory and is **invalid**

✔ `/home/pi/downloads/copyfiles/` is an absolute directory and is **valid**

`ntfscopy.sh monitor` will monitor what is going on

`ntfscopy.sh monitor verbose` will monitor what is going on in more detail.


