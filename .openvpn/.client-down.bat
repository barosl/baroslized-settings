#!/bin/sh

echo ; goto() { :; } # >nul
goto batch

mv /etc/resolv.conf.ovpn-ori /etc/resolv.conf

exit
:batch
