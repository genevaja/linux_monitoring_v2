#!/bin/bash

function check_arg () {
  local reg_expr="^([2][0][0-2][0-2])[-]{1}([0][1-9]|[1][0-2])[-]{1}([0][1-9]|[1-2][0-9]|[3][0-1])`
           `[/]{1}([0][0-9]|[1][0-9]|[2][0-3])[:]{1}([0-5][0-9])`
           `[/]{1}([0][0-9]|[1][0-9]|[2][0-3])[:]{1}([0-5][0-9])$"
  local result=""
  if [[ "$#" < 1 ]]; then
    echo "Enter date and time for search in YYYY-MM-DD/HH:MM/HH:MM `
         `(e.g. 2022-10-22/23:02/23:45 ):"
    while [[ 1 ]]
    do
      read choice
      if [[ $choice =~ $reg_expr ]]; then
        result=$(echo $choice | tr / ' ')
        date_time=$result
        return 0
      else
        echo -e "Wrong input. Try again.\n`
        `Date and time should be YYYY-MM-DD/HH:MM/HH:MM `
        `(e.g. 2022-10-22/23:02/23:45 ):"
      fi
    done
  else
    if [[ $1 =~ $reg_expr ]]; then
      result=$(echo $1 | tr / ' ')
      date_time=$result
      return 0
    else
      echo "Wrong parameter. Try interactive mode."
      check_arg
    fi
  fi
}

function second_method () {
  date_time=""
  check_arg $1 $date_time
  start_date=$(echo $date_time | awk '{printf("%s %s", $1, $2);}')
  end_date=$(echo $date_time | awk '{printf("%s %s", $1, $3);}')
  # Маска для даты
  name_mask=${start_date:5:2}${start_date:8:2}${start_date:2:2}
  find / -mindepth 1 -newermt "${start_date}" ! -newermt "${end_date}" -name "*$name_mask*" -delete 2>/dev/null
  return 0
}
