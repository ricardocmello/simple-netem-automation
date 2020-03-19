#! /bin/bash
clear
echo "---------------------------------------"
echo ""
echo "Starting Network Emulation using 'tc' "
echo ""
if [[ $# -ne 2 ]]; then
    echo "Error: please, specify two network interfaces to work with"
    echo "Exiting the program"
    exit 2
    else
        echo "We'll working with network interfaces "$1" "$2
        echo ""
fi
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
    echo "$ sudo tc qdisc add dev $1 root netem delay $delay_avg_1'ms' $delay_stdms_1 distribution $delay_dist_1"
    echo "$ sudo tc qdisc add dev $2 root netem delay $delay_avg_2'ms' $delay_stdms_2 distribution $delay_dist_2"
    sudo tc qdisc add dev $1 root netem delay $delay_avg_1'ms' $delay_std_1'ms' distribution $delay_dist_1
    sudo tc qdisc add dev $2 root netem delay $delay_avg_2'ms' $delay_std_2'ms' distribution $delay_dist_2
    elif [ "$emulated_network" = "loss only" ]; then
        echo "$ sudo tc qdisc change dev $1 root netem loss $loss_percentage_1%"
        echo "$ sudo tc qdisc change dev $2 root netem loss $loss_percentage_2%"
        sudo tc qdisc add dev $1 root netem loss $loss_percentage_1'%'
        sudo tc qdisc add dev $2 root netem loss $loss_percentage_2'%'
    elif [ "$emulated_network" = "delay and loss" ]; then
        echo "$ sudo tc qdisc add dev $1 root netem delay $delay_avg_1'ms' $delay_std_1'ms' distribution $delay_dist_1 loss $loss_percentage_1'%'"
        echo "$ sudo tc qdisc add dev $2 root netem delay $delay_avg_2'ms' $delay_std_2'ms' distribution $delay_dist_2 loss $loss_percentage_2'%'"
        sudo tc qdisc add dev $1 root netem delay $delay_av_1'ms' $delay_std_1'ms' distribution $delay_dist_1 loss $loss_percentage_1'%'
        sudo tc qdisc add dev $2 root netem delay $delay_avg_2'ms' $delay_std_2'ms' distribution $delay_dist_2 loss $loss_percentage_2'%'
    fi

echo ""
echo "---------------------------------------"
echo ""
echo "Press any key to exit program"
read  -n 1 -p "" to_exit
echo ""
echo "Cleaning up any rules before exiting"
sudo tc qdisc del dev $1 root
sudo tc qdisc del dev $2 root
echo ""
echo "Exiting the program"
exit 0