#!/bin/bash
config_file="$HOME/.config/hypr/conf/keybinding.conf"
echo "Reading from: $config_file"

keybinds=""

# Detect Start String
while read -r line
do
    if [[ "$line" == "bind"* ]]; then
        line="$(echo "$line" | sed 's/$mainMod/SUPER/g')"
        line="$(echo "$line" | sed 's/bind = //g')"
        line="$(echo "$line" | sed 's/bindm = //g')"

        IFS='#'
        read -a strarr <<<"$line"
        kb_str=${strarr[0]}
        cm_str=${strarr[1]}

        IFS=','
        read -a kbarr <<<"$kb_str"

        item="${kbarr[0]} +${kbarr[1]}"$'  -  '"${cm_str:1}"
        keybinds+=$item$'\n'
    fi
done < "$config_file"

keybinds="${keybinds%$'\n'}"

sleep 0.2
rofi -theme ~/.config/rofi/launchers/type-1/style-11.rasi -dmenu -i -markup -eh 2 -replace -p "Keybinds" <<< "$keybinds"
