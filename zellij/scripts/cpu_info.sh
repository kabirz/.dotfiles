#!/usr/bin/env bash

export LC_ALL=en_US.UTF-8

normalize_percent_len() {
  max_len=3
  percent_len=${#1}
  let diff_len=$max_len-$percent_len
  let left_spaces=($diff_len+1)/2
  let right_spaces=($diff_len)/2
  printf "CPU %${left_spaces}s%s%${right_spaces}s\n" "" $1 ""
}
case $(uname -s) in
  Linux)
    percent=$(LC_NUMERIC=en_US.UTF-8 top -bn2 -d 0.01 | grep "Cpu(s)" | tail -1 | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk '{print 100 - $1"%"}')
    normalize_percent_len $percent
    ;;

  Darwin)
    cpuvalue=$(ps -A -o %cpu | awk -F. '{s+=$1} END {print s}')
    cpucores=$(sysctl -n hw.logicalcpu)
    cpuusage=$(( cpuvalue / cpucores ))
    percent="$cpuusage%"
    normalize_percent_len $percent
    ;;

  *)
    ;;
esac
