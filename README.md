# Install

```
git clone https://github.com/MatthewCroughan/ntfscopy.git
cd ntfscopy
./install.sh
```

# Usage

Set the *absolute* path of the directory containing the contents you want via `ntfscopy.sh -d [directory]`

`home/pi` is a relative directory and will not work.
`~/home/pi` is also a relative directory and will not work.
`/home/pi/downloads/copyfiles/` is an absolute directory and will work.

`ntfscopy.sh monitor` will monitor what is going on
`ntfscopy.sh monitor verbose` will monitor what is going on in more detail.

