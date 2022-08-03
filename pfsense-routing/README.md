# pfsense-routing module

This module configures an existing pfsense VM for routing
of a homelab nested ESXi Lab instance. This assumes
an air gapped environment (Poor Man's air gap) by default
for the nested lab environment.

This script also sets up the necessary DNS entries for all
nested homelab systems and appliances, and minimal routing
rules in the pfsense firewall.

This script can optionally be used to enable Wireguard remote
access to a specific lab environment.