#!/bin/bash

source utils.sh

info="Hostname: $(hostname)\n"

info+="Timezone: $(cat /etc/timezone 2>/dev/null || date +'%Z')\n"

info+="User: $(whoami)\n"

info+="OS: $(cat /etc/issue | awk 'NR==1 {print $1, $2, $3}')\n"

info+="Date: $(date)\n"

info+="Uptime: $(uptime -p)\n"

calculate_uptime info

ip=$(ip addr show eno1 | grep 'inet ' | awk '{print $2}' | cut -f1 -d'/')
info+="IP: $ip\n"

mask=$(cidr_to_mask $cidr)

info+="Mask: /$mask\n" 

gateway=$(ip route | grep default | awk '{print $3}')
info+="Gateway: $gateway\n"

read ram_total ram_used ram_free <<<$(free -m | awk '/^Mem:/{print $2" "$3" "$4}')

# Преобразование значений из Мб в Гб с тремя знаками после запятой
ram_total_gb=$(echo "scale=3; $ram_total / 1024" | bc)
ram_used_gb=$(echo "scale=3; $ram_used / 1024" | bc)
ram_free_gb=$(echo "scale=3; $ram_free / 1024" | bc)


info+="Ram total: ${ram_total_gb} GB\n"

info+="Ram used: ${ram_used_gb} GB\n"

info+="Ram free: ${ram_free_gb} GB\n"

read space_root space_root_used space_root_avail <<<$(df -m / | awk 'NR==2 {print $2" "$3" "$4}')

space_root=$(printf "%.2f" $space_root)
space_root_used=$(printf "%.2f" $space_root_used)
space_root_free=$(printf "%.2f" $space_root_free)


info+="Space root: $space_root MB\n"

info+="Space root used: $space_root_used MB\n"

info+="Space Root Free: $space_root_free MB\n"

echo -e "$info"

ask_to_save_log "$info"
