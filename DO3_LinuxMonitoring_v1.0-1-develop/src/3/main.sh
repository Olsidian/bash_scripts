#!/bin/bash

source utils.sh

back1=$1
font1=$2
back2=$3
font2=$4

for arg in "$@"; do
  if ! [[ "$arg" =~ ^[1-6]$ ]]; then
    echo "Аргумент '$arg' не является числом от 1 до 6. Перезапустите скрипт с корректными аргументами."
    exit 1
  fi
done

if [[ $back1 == $font1 ]]; then
echo "Цвет фона и текста заглавия совпадают, перезапустите скрипт с несовпадающими цветами"
exit 1
fi

if [[ $back2 == $font2 ]]; then
echo "Цвет фона и текста значений совпадают, перезапустите скрипт с несовпадающими цветами"
exit 1
fi

declare -A colr
colr["1"]="\033[37m"
colr["2"]="\033[31m"
colr["3"]="\033[32m"
colr["4"]="\033[34m"
colr["5"]="\033[35m"
colr["6"]="\033[30m"
colr["reset"]="\033[0m"

declare -A colr_back
colr_back["1"]="\033[107m"
colr_back["2"]="\033[41m"
colr_back["3"]="\033[42m"
colr_back["4"]="\033[44m"
colr_back["5"]="\033[45m"
colr_back["6"]="\033[40m"
colr_back["reset"]="\033[49m"

info="${colr_back[$back1]}${colr[$font1]}Hostname:${colr_back["reset"]}${colr["reset"]} ${colr_back[$back2]}${colr[$font2]} $(hostname)${colr_back["reset"]}${colr["reset"]}\n"

info+="${colr_back[$back1]}${colr[$font1]}Timezone:${colr_back["reset"]}${colr["reset"]}  ${colr_back[$back2]}${colr[$font2]} $(cat /etc/timezone 2>/dev/null || date +'%Z') ${colr_back["reset"]}${colr["reset"]}\n"

info+="${colr_back[$back1]}${colr[$font1]}User:${colr_back["reset"]}${colr["reset"]}  ${colr_back[$back2]}${colr[$font2]} $(whoami) ${colr_back["reset"]}${colr["reset"]} \n"

info+="${colr_back[$back1]}${colr[$font1]}OS:${colr_back["reset"]}${colr["reset"]}  ${colr_back[$back2]}${colr[$font2]} $(cat /etc/issue | awk 'NR==1 {print $1, $2, $3}') ${colr_back["reset"]}${colr["reset"]}\n"

info+="${colr_back[$back1]}${colr[$font1]}Date:${colr_back["reset"]}${colr["reset"]}  ${colr_back[$back2]}${colr[$font2]} $(date) ${colr_back["reset"]}${colr["reset"]}\n"

info+="${colr_back[$back1]}${colr[$font1]}Uptime:${colr_back["reset"]}${colr["reset"]}  ${colr_back[$back2]}${colr[$font2]} $(uptime -p) ${colr_back["reset"]}${colr["reset"]}\n"

calculate_uptime uptime_sec

info+="${colr_back[$back1]}${colr[$font1]}Uptime (seconds):${colr_back["reset"]}${colr["reset"]}  ${colr_back[$back2]}${colr[$font2]} $uptime_sec ${colr_back["reset"]}${colr["reset"]}\n"

ip=$(ip addr show eno1 | grep 'inet ' | awk '{print $2}' | cut -f1 -d'/')
info+="${colr_back[$back1]}${colr[$font1]}IP:${colr_back["reset"]}${colr["reset"]}  ${colr_back[$back2]}${colr[$font2]} $ip ${colr_back["reset"]}${colr["reset"]}\n"

mask=$(cidr_to_mask $cidr)
info+="${colr_back[$back1]}${colr[$font1]}Mask:${colr_back["reset"]}${colr["reset"]}  ${colr_back[$back2]}${colr[$font2]} /$mask ${colr_back["reset"]}${colr["reset"]}\n" 

gateway=$(ip route | grep default | awk '{print $3}')
info+="${colr_back[$back1]}${colr[$font1]}Gateway:${colr_back["reset"]}${colr["reset"]}  ${colr_back[$back2]}${colr[$font2]} $gateway ${colr_back["reset"]}${colr["reset"]}\n"

ram_total=$(free -m | grep Mem: | awk '{print $2}')
info+="${colr_back[$back1]}${colr[$font1]}Ram total:${colr_back["reset"]}${colr["reset"]}  ${colr_back[$back2]}${colr[$font2]} ${ram_total}MB ${colr_back["reset"]}${colr["reset"]}\n"

ram_used=$(free -m | grep Mem: | awk '{print $3}')
info+="${colr_back[$back1]}${colr[$font1]}Ram used:${colr_back["reset"]}${colr["reset"]}  ${colr_back[$back2]}${colr[$font2]} ${ram_used}MB ${colr_back["reset"]}${colr["reset"]}\n"

ram_free=$(free -m | grep Mem: | awk '{print $4}')
info+="${colr_back[$back1]}${colr[$font1]}Ram free:${colr_back["reset"]}${colr["reset"]}  ${colr_back[$back2]}${colr[$font2]} ${ram_free}MB ${colr_back["reset"]}${colr["reset"]}\n"

space_root=$(df -h / | awk 'NR==2 {print $2}')
info+="${colr_back[$back1]}${colr[$font1]}Space root:${colr_back["reset"]}${colr["reset"]}  ${colr_back[$back2]}${colr[$font2]} $space_root ${colr_back["reset"]}${colr["reset"]}\n"

space_root_used=$(df -h / | awk 'NR==2 {print $3}')
info+="${colr_back[$back1]}${colr[$font1]}Space root used:${colr_back["reset"]}${colr["reset"]}  ${colr_back[$back2]}${colr[$font2]} $space_root_used ${colr_back["reset"]}${colr["reset"]}\n"

space_root_free=$(df -h / | awk 'NR==2 {print $4}')
info+="${colr_back[$back1]}${colr[$font1]}Spase Root Free:${colr_back["reset"]}${colr["reset"]}  ${colr_back[$back2]}${colr[$font2]} $space_root_free ${colr_back["reset"]}${colr["reset"]}\n"

echo -e "$info"
    

