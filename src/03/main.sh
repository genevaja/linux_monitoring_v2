#!/bin/bash

. ./first_method.sh
. ./second_method.sh
. ./third_method.sh

if [[ "$#" < 1 ]]; then
  echo -e "Choose method:\n\t1 - Deleting via log-file\n\t2 - Date and time of creation \
  \n\t3 - Name mask (e.g. qwe_102822)"
  exit 0
elif [[ $1 == 1 ]];then
  first_method
elif [[ $1 == 2 ]]; then
  second_method $2
elif [[ $1 == 3 ]]; then
  third_method $2
fi

exit 0
