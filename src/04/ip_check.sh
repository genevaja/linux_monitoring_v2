#!/bin/bash

# Считаем количество лог-файлов
log_count=$(ls *.log | wc -l)

for (( j=1; j<=$log_count; j++))
do
  temp_name=$j".log"
  wc_res=$(wc -l $temp_name | awk '{print $1}')
  temp=1
  for (( i=0; i<wc_res; i++ ))
  do
    temp=$(($i + $temp))
    ip_calc=$(ipcalc $(sed -n "$(($i + 1))"p $temp_name | awk '{print $1}') | awk 'NR==1{print $1}')
    if [[ "$ip_calc" = "INVALID" ]]; then
      echo "$(sed -n "$(($i + 1))"p $temp_name) INVALID"
    fi
  done
done
