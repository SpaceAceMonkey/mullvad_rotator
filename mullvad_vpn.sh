#!/bin/bash
# Select a random Mullvad WireGuard configuration file
# from /etc/wireguard/mullvad and use it to connect to
# connect to a Mullvad VPN endpoint.
################

down=0
# File in which to store the Mullvad configuration path
interface_file=/var/run/mullvad_configuration
# Include the trailing slash
config_path=/etc/wireguard/mullvad/

while [[ $# -gt 0 ]]; do
  case $1 in 
    -d|--down)
      down=1
      shift
      shift
  esac
done

if [[ $down = 1 ]]; then
  interface=$(cat $interface_file 2>/dev/null)
  if [[ -z $interface ]]; then
    echo "Failed to retrieve interface name from ${interface_file}."
  else
    echo "Attempting to bring down interface ${interface}."
    wg-quick down $interface
    if [[ $? = 0 ]]; then
      rm $interface_file
    fi
  fi
else
  if [[ -f $interface_file ]]; then
    echo "File $interface_file exists. Please be sure there is not already an"
    echo "active Mullvad connection before removing $inteface_file and proceeding."
  else
    config_file=$(find $config_path -maxdepth 1 -regextype posix-egrep -regex "^${config_path}[a-zA-Z0-9_.-]{1,16}\.conf" | sort -R | head -n1)
    intermediate=${config_file##*/}
    mullvad_interface=${intermediate%.conf}

    echo "Starting Mullvad VPN with configuration file $config_file."
    wg-quick up $config_file
    if [[ $? = 0 ]]; then
      echo "Mullvad interface: $mullvad_interface"
      echo $config_file > $interface_file
    fi
  fi
fi

