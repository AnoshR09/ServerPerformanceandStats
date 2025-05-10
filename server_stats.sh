#!/bin/bash

# This script is to monitor server performance
# Function to get CPU usage

echo "This script is to monitor server performance"


get_cpu_usage() {
	echo "CPU Utilization:"
	mpstat | awk '$12~/[0-9.]+/{print 100-$12"% used"}'
}

get_memory_usage() {
	echo "Memory Utilization:"
	free -m | awk 'NR==2{printf"Used: %sMB/Out of: %sMB(%.2f%%)\n",$3,$2,$3*100/$2}'

}

get_disk_usage(){
	echo "Disk Utilization"
	df -h --total | awk 'END{print"Used:"$3",Free:"$4",Usage:"$5}'

}	

get_top_cpu_usage(){
	echo "Top 5 processes utilizing CPU"
	ps -eo pid,ppid,cmd,%mem,%cpu --sort=-%cpu | head -n 6
	echo "Top 5 processes utilizing Memory"
	ps -eo pid,ppid,cmd,%mem,%cpu --sort=-%mem | head -n 6

}

get_loggedin_user(){
	echo "Logged in User"
	who
}

get_extra(){
	echo "System Uptime"
	uptime
	echo "Last Boot"
	who -b
}	



main(){
	echo "Server Performance Stats"
	echo "-------------------------"
	get_loggedin_user
	get_cpu_usage
	get_memory_usage
	get_disk_usage
	get_top_cpu_usage
	get_extra
}

main
