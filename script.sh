#! /bin/bash

clear
echo "---------------------------------------"
echo ""
echo "Starting Network Emulation using 'tc' "
echo ""
sleep 1
echo "Choose a config file"
echo "1: test_delay.config"
echo "2: test_loss.config"
echo "3: test_delay_and_loss.config"
read -n 1 -p "Config selection: " config_input
if [ "$config_input" = "1" ]; then
        config_file="test_delay.config"
    elif [ "$config_input" = "2" ]; then
        config_file="test_loss.config"
    elif [ "$config_input" = "3" ]; then
        config_file="test_delay_and_loss.config"
    else
        echo ""
        echo "You have entered an invallid selection!"
        echo "Exiting program"
        exit 0
    fi
clear
sleep 0.5
echo ""
echo "Importing the following config file: "$config_file
echo ""
. $config_file

echo "---------------------------------------"
echo ""
echo "Emulation: $emulated_network"
echo ""
echo "---------------------------------------"

echo ""
echo "Executing the following commands:"
if [ "$emulated_network" = "delay only" ]; then
    echo "$ sudo tc qdisc add dev $nic_name root netem delay $delay_avg'ms' $delay_stdms distribution $delay_dist"
    sudo tc qdisc add dev $nic_name root netem delay $delay_avg'ms' $delay_std'ms' distribution $delay_dist
     elif [ "$emulated_network" = "loss only" ]; then
        echo "$ sudo tc qdisc change dev $nic_name root netem loss $loss_percentage%"
        sudo tc qdisc add dev $nic_name root netem loss $loss_percentage'%'
    elif [ "$emulated_network" = "delay and loss" ]; then
        echo "$ sudo tc qdisc add dev $nic_name root netem delay $delay_avg'ms' $delay_std'ms' distribution $delay_dist loss $loss_percentage'%'"
        sudo tc qdisc add dev $nic_name root netem delay $delay_avg'ms' $delay_std'ms' distribution $delay_dist loss $loss_percentage'%'
    fi

echo ""
echo "---------------------------------------"
echo ""
echo "Press any key to exit program"
read  -n 1 -p "" to_exit
echo ""
echo "Cleaning up any rules before exiting"
sudo tc qdisc del dev $nic_name root
echo ""
echo "Exiting the program"
exit 0