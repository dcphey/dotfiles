#!/bin/sh

S="\tShutdown"
R="\tRestart"
D="\tSuspend"
L="\tLock"
O="\tLogout"

if [ x"${1:0:1}" = x"${S:0:1}" ]
then
    systemctl poweroff
    exit 0
elif [ x"${1:0:1}" = x"${R:0:1}" ]
then
    systemctl reboot
    exit 0
elif [ x"${1:0:1}" = x"${D:0:1}" ]
then
    systemctl suspend
    exit 0
elif [ x"${1:0:1}" = x"${L:0:1}" ]
then
    coproc (hyprlock > /dev/null 2>&1)
    exit 0
elif [ x"${1:0:1}" = x"${O:0:1}" ]
then
    uwsm stop
    exit 0
fi

echo -e "\0theme\x1flistview{lines: none;}\n"
echo -e "$S\n$R\n$D\n$L\n$O"
