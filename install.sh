if [[ $USER == "root" ]]; then
  echo "This script must not be run as root!"
  exit 1
fi

# Make config directory
mkdir -p ~/.config/ntfscopy/

# Get position of the script so that this being ran from elsewhere in the system doesn't impact the script
cd "$( cd -P "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"


# We'll need ntfs-3g. Install it if needed.
if [ -z "$(which ntfs-3g)" ]; then
	echo "I need ntfs-3g and it's missing. I'll install it."
	sudo apt-get -y update
	sudo apt-get --no-install-recommends -y install ntfs-3g
fi

# We'll need at. Install it if needed.
if [ -z "$(which at)" ]; then
	echo "I need at and it's missing. I'll install it."
	sudo apt-get -y update
	sudo apt-get --no-install-recommends -y install at
fi

# Install
sudo cp ./ntfscopy.sh /usr/local/bin/ntfscopy.sh
sudo cp ./detected.sh /usr/local/bin/detected.sh

echo 'KERNEL=="sd[a-z]", SUBSYSTEM=="block", ACTION=="add", RUN+="/usr/bin/sudo /usr/local/bin/detected.sh $name"' | sudo tee /etc/udev/rules.d/99-ntfscopy.rules

sudo udevadm control --reload-rules

