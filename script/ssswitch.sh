#!/bin/bash
# This is a script for swithing shadowsocks config

# get current config
current_config=$(systemctl status | grep shadowsocks@ | grep -v grep | sed -n 's/.*@\(.*\)\.service/\1/p')

# list available config
config_directory=/etc/shadowsocks/
declare -a configs
declare -i index=0
echo "Hear are available configs:"
for config in $(ls $config_directory | cut -d '.' -f 1); do
    if [ $config == $current_config ]; then
        echo -e "    \033[32m$index: $config(running...)\033[0m"
    else
        echo "    $index: $config"
    fi
    configs[$index]=$config
    index=$index+1
done

# switch to config user chosed
declare -i target
read -p "Choose a config file you want to switch(0~$(($index - 1))): " target
if [[ target -ge $index || target -lt 0 ]]; then
    echo "Input not available."
    exit 10
else
    echo "stopping $current_config.service..."
    sudo systemctl stop shadowsocks@$current_config
    echo "starting ${configs[$target]}..."
    sudo systemctl start shadowsocks@${configs[$target]}
    echo "Done!"
fi
