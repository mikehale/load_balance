# Clusterip

Uses the iptables CLUSTERIP target to create an ip address that is shared between multiple hosts.

## Usage

You need to define the following attributes

`:cluster => {:members => %w[member1 member2], :ip => "shared.ip.address", :mac => "01:00:5e:xx:xx:xx"}`

The mac address should begin with 01:00:5e to indicate that it is a multicast mac address.

## Todo
* don't completely reset iptables rules
* use heartbeat/keepalived to notify healthy nodes when a node dies and take over its job
* need some way to track and sync connections between boxes to avoid dropped connections. Is this possible?
