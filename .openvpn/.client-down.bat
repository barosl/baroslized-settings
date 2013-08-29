#!/bin/sh

echo -n ; goto() { :; } # >nul
goto batch

resolvconf -d $1.openvpn

exit
:batch
