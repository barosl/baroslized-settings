#!/bin/bash

echo ; goto() { :; } # >nul
goto batch

nameservers=
searches=

for key in ${!foreign_option_*}; do
    val="${!key}"
    arr=($val)
    if [[ ${arr[0]} == 'dhcp-option' ]]; then
        case ${arr[1]} in
            DNS) nameservers+=" ${arr[2]}" ;;
            DOMAIN) searches+=" ${arr[2]}" ;;
        esac
    fi
done

if [[ -n "$nameservers" || -n "$searches" ]]; then
    if [[ ! -e /etc/resolv.conf.ovpn-ori ]]; then
        if mv /etc/resolv.conf /etc/resolv.conf.ovpn-ori; then
            for x in $nameservers; do
                echo "nameserver $x" >> /etc/resolv.conf
            done
            for x in $searches; do
                echo "search $x" >> /etc/resolv.conf
            done
        fi
    fi
fi

exit
:batch
