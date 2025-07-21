#!/bin/bash
# This script displays basic server performance statistics

# Print header
echo "==================== SERVER STATS ===================="

# ----------- CPU Usage -----------
echo -e "\n🔧 Total CPU Usage:"
# Use 'top' command in batch mode (-b), 1 iteration (-n1)
# Filter line with "Cpu(s)", then use 'awk' to format output
# $8 is the idle CPU percentage, so (100 - idle) = used
top -bn1 | grep "Cpu(s)" | \
awk '{printf "Used: %.1f%%, Idle: %.1f%%\n", 100 - $8, $8}'

# ----------- Memory Usage -----------
echo -e "\n🧠 Total Memory Usage:"
# Use 'free -h' to get human-readable memory stats
# 'awk' extracts total and used memory and calculates percentage
free -h | awk '
/Mem:/ {
  printf "Used: %s / %s (%.1f%%)\n", $3, $2, ($3/$2)*100
}'

# ----------- Disk Usage -----------
echo -e "\n💾 Total Disk Usage (root '/'):"
# Use 'df -h /' to get disk usage of root partition in human-readable format
# 'awk' skips header and formats used, total, and percentage used
df -h / | awk 'NR==2 {
  printf "Used: %s / %s (%s used)\n", $3, $2, $5
}'

# ----------- Top 5 CPU-consuming Processes -----------
echo -e "\n🔥 Top 5 Processes by CPU Usage:"
# 'ps -eo' lists all processes with PID, command name, and CPU usage
# '--sort=-%cpu' sorts them in descending order of CPU usage
# 'head -n 6' gets top 5 plus header
# 'awk' formats and aligns the output columns
ps -eo pid,comm,%cpu --sort=-%cpu | head -n 6 | \
awk 'NR==1 { printf "%-8s %-20s %s\n", "PID", "COMMAND", "CPU%" }
     NR>1  { printf "%-8s %-20s %.1f\n", $1, $2, $3 }'

# ----------- Top 5 Memory-consuming Processes -----------
echo -e "\n🧵 Top 5 Processes by Memory Usage:"
# Similar to above, but sorted by memory usage
ps -eo pid,comm,%mem --sort=-%mem | head -n 6 | \
awk 'NR==1 { printf "%-8s %-20s %s\n", "PID", "COMMAND", "MEM%" }
     NR>1  { printf "%-8s %-20s %.1f\n", $1, $2, $3 }'

# End of script output
echo -e "\n======================================================"
