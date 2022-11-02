#!/bin/bash

function check_arg_third () {
  local reg_expr="^[a-zA-Z]{1,7}[_]{1}[0-9]{6}"
  if [[ ! $1 =~ $reg_expr ]]; then
    echo "Wrong parameters"
    echo "Must be letter from 1 to 7 characters, underscore and date in MMDDYY"
    echo "e.g. abcd_102522"
    return 1
  else
    return 0
  fi
}

function get_expr () {
  local temp_arg=$(echo $1 | tr _ ' ')
  local letter_arg=$(echo $temp_arg | awk '{print $1}')
  local date_arg=$(echo $temp_arg | awk '{print $2}')
  local regex_for_search="*"
  for (( i=0; i < $(expr length "$letter_arg"); i++))
  do
    regex_for_search=$regex_for_search${letter_arg:$i:1}
    regex_for_search=$regex_for_search"*"
  done
  regex_for_search=$regex_for_search"_"$date_arg"*"
  echo $regex_for_search
}

function third_method () {
  check_arg_third $1
  if [[ $? == 1 ]]; then
    exit 1
  fi
  expression_for_search=$(get_expr $1)
  find / -name "$expression_for_search" -exec rm -rf {} \; 2> /dev/null
  return 0
}
