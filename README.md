# parp
Simple Arp Poisoning script made in Perl
# Usage
Run as root:  
`usage: ./parp.pl [iface]`
- iface being your network interface
# What does it do
This script will send `ARP packet`  
to all the clients of the network saying that  
`the Gateway IP` is linked to `your Mac Addr`,  
then the packets that aim the gateway  
will be sent with `your Mac Addr`, so to you :).
