#!/bin/bash

CURRENT_LAYOUT=$(setxkbmap -query|awk -F : 'NR==4{print $2}'|sed 's/ //g')

if [ "$CURRENT_LAYOUT" = "" ]; then
    setxkbmap -layout "rs" -variant "latin"
elif [ "$CURRENT_LAYOUT" = "latin" ]; then
    setxkbmap -layout "rs" -variant "yz"
else
    setxkbmap -layout "us"
fi

