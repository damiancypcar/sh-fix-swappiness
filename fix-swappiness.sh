#!/usr/bin/env bash
# ----------------------------------------------------------
# Author:       damiancypcar
# Modified:     12.05.2023
# Version:      1.0
# Desc:         Fix swappiness & vfs_cache_pressure levels
# ----------------------------------------------------------
set -euo pipefail

# shellcheck disable=SC2046
if [ $(id -u) -ne 0 ]; then
    echo "You must be ROOT to run this script"
    exit 1
fi

SWLEVEL='5'
VFSCACHE='50'
SYSFILE='/etc/sysctl.conf'

echo "Curr. swappiness: $(cat /proc/sys/vm/swappiness)"
echo "Curr. vfs_cache_pressure: $(cat /proc/sys/vm/vfs_cache_pressure)"
echo
echo "NEW swappiness: $SWLEVEL"
echo "NEW vfs_cache_pressure: $VFSCACHE"
echo

run() {
    echo "Setting new values..."
    {
    echo
    echo "# new swappiness level"
    echo "vm.swappiness = $SWLEVEL"
    echo "# new vfs_cache_pressure level"
    echo "vm.vfs_cache_pressure = $VFSCACHE"
    echo 
    } >> $SYSFILE
    echo "Reload settings"
    sysctl -p
}

read -rp "Do you want set new values? (y/N) " yn
if [ -z $yn ]; then yn="n"; fi
case $yn in
    [Yy]* ) run;;
    [Nn]* ) echo "Exiting."; exit;;
        * ) echo "Invalid response"; exit 1;;
esac
