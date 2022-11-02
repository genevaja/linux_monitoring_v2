#!/bin/bash

function first_method () {
  log_path="../02/log.txt"
  qty_lines=$(($(wc -l "$log_path" | awk '{print $1}') - 3))
  number=1
  for (( i=0; i<$qty_lines; i++ ))
  do
    rm -rf $(sed -n "$number"p $log_path | awk '{print $1}') 2> /dev/null
    (( number += 1 ))
  done
  return 0
}
