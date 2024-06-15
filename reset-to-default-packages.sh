#!/bin/bash

# Get the list of installed packages
dpkg-query -W -f='${binary:Package}\n' > installed-packages.txt

# Download the default package list (update the URL to the correct one if needed)
wget http://releases.ubuntu.com/24.04/ubuntu-24.04-desktop-amd64.manifest -O default-packages.txt

# Extract package names from the default list
awk '{print $1}' default-packages.txt > default-packages-names.txt

# Sort the lists
sort installed-packages.txt -o installed-packages.txt
sort default-packages-names.txt -o default-packages-names.txt

# Find non-default packages
comm -23 installed-packages.txt default-packages-names.txt > non-default-packages.txt

# Verify non-default packages
echo "Non-default packages to be removed:"
cat non-default-packages.txt

# Uninstall non-default packages
xargs sudo apt-get remove --purge -y < non-default-packages.txt

# Clean up
sudo apt-get autoremove -y
sudo apt-get autoclean -y

# Remove generated files
rm default-packages-names.txt default-packages.txt installed-packages.txt non-default-packages.txt


echo "System reset to default package state and cleanup completed."
