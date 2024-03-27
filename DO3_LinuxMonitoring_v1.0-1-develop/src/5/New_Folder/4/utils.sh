#!/bin/bash

calculate_uptime() {
    local -n info=$1
    boot_time=$(date -d "$(uptime -s)" +%s)
    current_time=$(date +%s)
    uptime_sec=$((current_time - boot_time))
}
 

# Получить CIDR первого не-loopback интерфейса

interface=$(ip -o -4 addr show | awk '$2 != "lo" {print $2}' | head -n 1)
cidr=$(ip addr show $interface | grep 'inet ' | awk '{print $2}' | cut -f2 -d'/' | head -n 1)

cidr_to_mask() {
    local cidr=$1
    local i binary_mask

    # Создаем бинарную маску. Например, для /24 это будет 11111111111111111111111100000000
    for ((i=1; i<=32; i++)); do
        if [[ $i -le $cidr ]]; then
            binary_mask+="1"
        else
            binary_mask+="0"
        fi
    done

    # Разделяем бинарную маску на 4 части и конвертируем их в десятичный формат
    binary1=${binary_mask:0:8}
    binary2=${binary_mask:8:8}
    binary3=${binary_mask:16:8}
    binary4=${binary_mask:24:8}

    mask1=$((2#$binary1))
    mask2=$((2#$binary2))
    mask3=$((2#$binary3))
    mask4=$((2#$binary4))

    echo "$mask1.$mask2.$mask3.$mask4"
}

