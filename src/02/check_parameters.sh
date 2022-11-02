#!/bin/bash

function comm_args_error {
  >&2 echo -e "Must be 3 parameters:
  \t1. Letters used in folder names (maximum 7 characters)
  \t2. Letters used in file names and extention (maximum 7 characters for name, 
  \t   3 for extention)
  \t3. File size (in MB, maximum 100 MB)"
}

# Считаем количество символов до точки и после точки и проверяем корректность параметра
function check_str () {
  str_length=$(expr length "$1")
  before_dot=$( expr match "$1" '.*[.]' - 1)
  after_dot=$(expr length "$1" - $before_dot - 1)
  temp_str=""
  for (( i=0; i < $before_dot; i++ ))
  do
    expr_res=$(expr index "$temp_str" ${1:$i:1})
    if [[ $expr_res != 0 ]]; then
        if [[ $2 == 5 ]]; then
          >&2 echo "Name characters in 2 parameter must be different"
          return 1
        elif [[ $2 == 3 ]]; then
          >&2 echo "Characters in 1 parameter must be different"
          return 1
        fi
    fi
    temp_str=$temp_str$(echo ${1:$i:1})
  done
  if [[ $(expr match "$1" '.') == 1 ]]; then
    temp_str2=""
    for (( i=$before_dot+1; i < $str_length; i++ ))
    do
      expr_res=$(expr index "$temp_str2" ${1:$i:1})
      if [[ $expr_res != 0 ]]; then
        if [[ $2 == 5 ]]; then
          >&2 echo "Extention characters in 2 parameter must be different"
          return 1
        elif [[ $2 == 3 ]]; then
          >&2 echo "Characters in 1 parameter must be different"
          return 1
        fi
      fi
      temp_str2+=$(echo ${1:$i:1})
    done
  fi
  return 0
}


function check_arg () {
  fn_result=0

  # Check first parameter
  if [[ ! "$1" =~ ^[a-zA-Z]+$ ]]; then
    >&2 echo "First parameter must be letter a-z and A-Z"
    fn_result=1
  fi
  if [[ ${#1} > 7 ]]; then
    >&2 echo "First parameter must be less then 8 characters"
    fn_result=1
  fi
  if [[ $(check_str $1 3) == 1 ]]; then
    >&2 echo "First parameter must be less then 8 characters"
    fn_result=1
  fi

  # Check second parameter
  if [[ "$2" =~ ^[a-zA-Z]{1,7}[.]{1}[a-zA-Z]{1,3}$ ]]; then
    check_str $2 5
  else
    >&2 echo "Second parameter must contain max 7 alphabetic char for file name"
    >&2 echo "Second parameter must contain max 3 alphabetic char for file extention"
    >&2 echo "Example: abcdefg.abc"
    fn_result=1
  fi


  # Check third parameter
  if [[ ! "$3" =~ ^([1-9]|[1-9][0-9]|[1][0][0])(Mb)$ ]]; then
    >&2 echo "Third parameter must be less then 100Mb with \"Mb\" extention"
    fn_result=1
  fi

  if [ "$fn_result" -eq 0 ]; then
    return 0
  else
    return 1
  fi
}
