# Mullvad VPN rotator

A small script and systemd service file to connect your machine to 
the Mullvad VPN network.


#### Installation

All steps are for Ubuntu 20.04, and might need adaptation for your system.
These instructions assume you have a working WireGuard install and Mullvad
configuration files.

Copy `mullvad_vpn.sh` to wherever suits you on your machine. If desired,
you may open `mullvad_vpn.sh` and update `interface_file` and 
`config_path` to suit your needs.

Modify mullvad_vpn.service to change all occurrences of
`/usr/local/bin/mullvad_vpn.sh` to point to wherever you moved
`mullvad_vpn.sh`.

Copy as many Mullvad configuration files as you wish to the `config_path`
specified in `mullvad_vpn.sh`.

Copy `mullvad_vpn.service` to `/etc/systemd/system`.

Execute `sudo systemd daemon-reload`.

Execute `sudo systemctl start mullvad_vpn` to turn on the VPN. Use 
`sudo systemctl stop mullvad_vpn` to turn off the VPN. Each time you
start the VPN service, a configuration file will be chosen at random
from the ones you copied to `config_path` in a previous step.

Use `sudo systemctl enable mullvad_vpn` to have the service start each
time your system starts.
