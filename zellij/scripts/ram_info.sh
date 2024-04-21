#!/usr/bin/env bash

export LC_ALL=en_US.UTF-8

case $(uname -s) in
  Linux)
    usage="$(free -h | awk 'NR==2 {print $3}')"
    total="$(free -h | awk 'NR==2 {print $2}')"
    formated="${usage}/${total}"
    
    echo "RAM ${formated//i/B}"
    ;;

  Darwin)
    used_mem=$(vm_stat | grep ' active\|wired ' | sed 's/[^0-9]//g' | paste -sd ' ' - | awk -v pagesize=$(pagesize) '{printf "%d\n", ($1+$2) * pagesize / 1048576}')
    total_mem=$(system_profiler SPHardwareDataType | grep "Memory:" | awk '{print $2 $3}')
    if ((used_mem < 1024 )); then
      echo "RAM ${used_mem}MB/$total_mem"
    else
      memory=$((used_mem/1024))
      echo "RAM ${memory}GB/$total_mem"
    fi
    ;;

   *)
    ;;
esac
