#!/bin/bash

echo "permssive selinuxing"
sudo setenforce 0
sudo sed -i 's/^SELINUX=enforcing/SELINUX=permissive/' /etc/selinux/config

# 1. Clear out the broken Fedora compressed firmware files
echo "Purging old compressed system archives..."
sudo rm -rf /lib/firmware/intel/sof
sudo rm -rf /lib/firmware/intel/sof-tplg

echo "getting sof firmware plzz wait"
cd ~
wget https://github.com/thesofproject/sof-bin/releases/download/v2024.03/sof-bin-2024.03.tar.gz

echo "taking out files"
tar -xf sof-bin-2024.03.tar.gz
cd sof-bin-2024.03 || { echo "extraction directory missing! did it download?"; exit 1; }

echo "files are getting deported plz wait"
sudo mkdir -p /lib/firmware/intel
sudo cp -r v2.2.x/sof-v2.2 /lib/firmware/intel/sof
sudo cp -r v2.2.x/sof-tplg-v2.2 /lib/firmware/intel/sof-tplg


echo "applying WeirdTreeThing's audio"
cd "$HOME/fedora-alder-lake-fix" || { echo "where da chromebook-linux-audio?"; exit 1; }
./setup-audio

echo "getting rid of trash"
rm -rf "$HOME/.local/state/wireplumber/"*
rm -rf "$HOME/.config/pulse/"*


echo "restarting hardware"
sudo udevadm trigger

rm -rf "$HOME/sof-bin-2024.03" "$HOME/sof-bin-2024.03.tar.gz

echo "rebooting in 5s"
sleep 5
sudo reboot


