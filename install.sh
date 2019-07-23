# Check if root
if [ $EUID != 0 ]; then
    sudo "$0" "$@"
    exit $?
fi

# Make config directory
mkdir ~/.config/ntfscopy/

# Get position of the script so that this being ran from elsewhere in the system doesn't impact the script
SOURCE="${BASH_SOURCE[0]}"
DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"

# We'll need ntfs-3g. Install it if needed.
if [ -z "$(which ntfs-3g)" ]; then
	echo "I need ntfs-3g and it's missing. I'll install it."
	apt-get -y update
	apt-get --no-install-recommends -y install ntfs-3g
fi

# We'll need at. Install it if needed.
if [ -z "$(which at)" ]; then
	echo "I need at and it's missing. I'll install it."
	apt-get -y update
	apt-get --no-install-recommends -y install at
fi

# Install
cp ./ntfscopy.sh /usr/local/bin/ntfscopy.sh
cp ./detected.sh /usr/local/bin/detected.sh

echo 'KERNEL=="sd[a-z]", SUBSYSTEM=="block", ACTION=="add", RUN+="/usr/bin/sudo /usr/local/bin/ntfscopy/detected.sh $name"' | sudo tee /etc/udev/rules.d/99-ntfscopy.rules

sudo udevadm control --reload-rules

