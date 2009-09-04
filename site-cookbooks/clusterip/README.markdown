# Clusterip

Uses the iptables CLUSTERIP target to create an ip address that is shared between multiple hosts.

## Todo
* don't completely reset iptables rules
* use heartbeat/keepalived to notify healthy nodes when a node dies and take over its job
* need some way to track and sync connections between boxes to avoid dropped connections. Is this possible?
