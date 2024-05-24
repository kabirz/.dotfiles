#!/usr/bin/env bash

export LC_ALL=en_US.UTF-8

case $(uname -s) in
  Linux)
    percent=$(LC_NUMERIC=en_US.UTF-8 top -bn2 -d 0.01 | grep "Cpu(s)" | tail -1 | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk '{print 100 - $1}')
    printf "CPU %4s%%" $percent
    ;;

  Darwin)
    cpuvalue=$(ps -A -o %cpu | awk -F. '{s+=$1} END {print s}')
    cpucores=$(sysctl -n hw.logicalcpu)
    cpuusage=$(( cpuvalue / cpucores ))
    printf "CPU %4s%%" $cpuusage
    ;;

  *)
    ;;
esac
