#!/bin/sh

echo -n ; goto() { :; } # >nul
goto batch

set | sed -n "s/^foreign_option_.*'dhcp-option DNS \\(.*\\)'/nameserver \\1/; s/^foreign_option_.*'dhcp-option DOMAIN \\(.*\\)'/search \\1/; T; p" | resolvconf -a $1.openvpn

exit
:batch
