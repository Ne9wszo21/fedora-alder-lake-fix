#!/bin/bash

if [ "$EUID" -ne 0 ]; then
    echo "Error: This script must be run with sudo!"
    exit 1
fi

echo "Running complete audio restoration: Configures SELinux, clears broken firmware compressed paths, applies uncompressed Alder Lake-N blobs, triggers custom speaker routing, flushes audio session cache, and reboots..."

setenforce 0
sed -i 's/^SELINUX=enforcing/SELINUX=permissive/' /etc/selinux/config

rm -rf /lib/firmware/intel/sof
rm -rf /lib/firmware/intel/sof-tplg

mkdir -p /lib/firmware/intel

USER_HOME=$(eval echo "~$SUDO_USER")

cd "$USER_HOME/fedora-alder-lake-fix" || { exit 1; }
cp -r blobs/v2.2.x/sof-v2.2 /lib/firmware/intel/sof
cp -r blobs/v2.2.x/sof-tplg-v2.2 /lib/firmware/intel/sof-tplg

./setup-audio

rm -rf "$USER_HOME/.local/state/wireplumber/"*
rm -rf "$USER_HOME/.config/pulse/"*

udevadm trigger

sleep 5
reboot
