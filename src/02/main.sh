#!/bin/bash

. ./check_parameters.sh
. ./create_files.sh

time=$(date +%s%N)
time2=$(date +%H:%M)

# Check number of arguments
if [[ "$#" < 3 || "$#" > 3 ]]; then
  comm_args_error
  exit 1
fi

# Check each argument
check_arg "$1" "$2" "$3"
exit_code=$?
if [[ "$exit_code" == 0 ]]; then
  create_files "$1" "$2" "$3"
  exit_code=$?
  exec_time=$(date +%s%N)
  exec_time2=$(date +%H:%M)

  diff=$(( $exec_time - $time ))
  diff=$(bc<<<"scale=3;$diff/1000000000")
  if [[ $(( ($exec_time - $time)/1000000000)) -lt 1 ]]; then
      zero="0"
  fi

  echo "* Start execution script: $time2" | tee -a ./log.txt
  echo "* End execution script: $exec_time2" | tee -a ./log.txt
  printf "* Script execution time (in seconds) = %s%s\n" $zero $diff | tee -a ./log.txt
fi

exit $exit_code
