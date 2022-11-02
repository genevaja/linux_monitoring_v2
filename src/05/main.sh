#!/bin/bash

if [[ $# -ne 1 ]]; then
  echo "Specify one option: 1, 2, 3, 4"
fi
if [[ $1 -eq 1 ]]; then
  awk '{print $0}' ../04/*.log | sort -k8
elif [[ $1 -eq 2 ]]; then
  cat ../04/*.log | awk '{print $1}' | sort -u
elif [[ $1 -eq 3 ]]; then
  grep -E '[45][0-9]{2}' ../04/*.log | awk '{print $0}'
elif [[ $1 -eq 4 ]]; then
  grep -E '[5][0-9]{2}' -h ../04/*.log | awk '{print $1}' | sort -u
fi

exit_code=$?

exit $?
