The Plan: Automating Server Monitoring
Before jumping into the code, I outlined what exactly I wanted my script to do:

Show total CPU usage in real-time.
Display total memory usage free vs. used.
Check disk usage across the filesystem.
List the top 5 processes consuming CPU and memory.
Optionally, show extra stats like OS version, uptime, load averages, and users logged into the system.
This seemed like a solid starting point. The script should be simple enough to run on any Linux server, and should provide all the crucial stats in one go.

Setting Up the Environment
The beauty of Bash scripting is that it’s native to Linux. If you’re using a Unix-based system (Ubuntu, CentOS, etc.), you already have all the tools you need to get started. The commands we’ll use mpstat, free, df, and ps are available on most distributions. If not, they can be installed easily.

Now, let’s get to the fun part coding.

Writing the Script: Step by Step
I broke the project down into small, manageable tasks, each representing a function in the script. Here’s a breakdown of each component.

1. Monitoring CPU Usage
The first thing I wanted to know is how much of my CPU is being used. For this, I used the mpstat command. This command provides CPU usage statistics, but I needed to extract the relevant information specifically, the percentage of the CPU being utilized.

get_cpu_usage(){
echo “CPU Usage:”
mpstat | awk ‘$12 ~ /[0–9.]+/ { print 100 -$12"% used” }’
}

In the script, I used awk to subtract the idle CPU percentage from 100, which gives the actual CPU usage. This gives me a quick snapshot of how busy my server is.

2. Displaying Memory Usage
Next, I wanted to display how much memory is in use, both in MB and as a percentage. The free command is perfect for this, as it shows total, used, and free memory.

get_memory_usage() {
        echo "Memory Utilization:"
        free -m | awk 'NR==2{printf"Used: %sMB/Out of: %sMB(%.2f%%)\n",$3,$2,$3*100/$2}'

}

Here, free -m shows memory in MB, and using awk, I calculate the used memory as a percentage of total memory. It’s clear, concise, and gives me exactly what I need.

3. Checking Disk Usage
Disk usage is critical, especially when dealing with storage-intensive applications. The df -h command provides human-readable disk usage stats. I wrapped it into a simple function.

get_disk_usage(){
        echo "Disk Utilization"
        df -h --total | awk 'END{print"Used:"$3",Free:"$4",Usage:"$5}'

}

By using the --total flag, I can check the disk usage across all mounted filesystems and print out the total used and free space, along with the usage percentage.

4. Listing Top Processes by CPU and Memory Usage
One of the common troubleshooting steps is identifying processes that are hogging CPU or memory. To list the top 5 processes by CPU usage, I used the ps command.

get_top_cpu_and_mem_usage(){
        echo "Top 5 processes utilizing CPU"
        ps -eo pid,ppid,cmd,%mem,%cpu --sort=-%cpu | head -n 6
        echo "Top 5 processes utilizing Memory"
        ps -eo pid,ppid,cmd,%mem,%cpu --sort=-%mem | head -n 6

}

With this, I could easily spot resource-hungry processes and take action if needed.

5. Bonus: Extra System Stats
As an optional step, I added some extra stats like OS version, uptime, load average, and logged-in users. These aren’t essential for performance monitoring, but they add context when you’re analyzing the health of your server.

get_extra_stats(){
        echo “OS Version:”
        lsb_release -a 2>/dev/null || cat /etc/os-release


echo “Uptime:”
uptime

echo “Load Average:”
cat /proc/loadavg

echo “Logged in users:”
who

}

These commands give you a comprehensive view of your server environment in case you need deeper insight into the system.

Bringing It All Together: The Final Script
Once all the pieces were in place, I structured the script into a main function that calls each of these smaller functions:

main(){
echo “Server Performance Stats”
echo “ — — — — — — — — — — — — — — — -”
get_cpu_usage
get_memory_usage
get_disk_usage
get_top_cpu_processes
get_top_mem_processes
get_extra_stats
}

This is where everything comes together, and I can execute the script with a single command to get a full report on the server’s performance.

Testing the Script
After writing the script, I ran it on a few different Linux servers to make sure it worked consistently. The results were exactly what I hoped for — a quick, easy-to-read report that gave me all the key performance stats at a glance.

Conclusion
Building this Bash script was a great learning experience. Not only did I automate a manual process that I had been doing over and over again, but I also got to dive deeper into Linux performance commands. If you’re new to Bash scripting or Linux system administration, I encourage you to give this project a try. It’s practical, useful, and will undoubtedly sharpen your scripting skills.

This project is part of the DevOps roadmap — a series of hands-on projects designed to build foundational skills in DevOps.
