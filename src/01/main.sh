#!/bin/bash

. ./check_parameters.sh
. ./create_files.sh

# Check number of arguments
if [[ "$#" < 6 || "$#" > 6 ]]; then
  comm_args_error
  exit 1
fi

# Check each argument
check_arg "$1" "$2" "$3" "$4" "$5" "$6"
exit_code=$?
if [[ "$exit_code" == 0 ]]; then
  create_files "$1" "$2" "$3" "$4" "$5" "$6"
  exit_code=$?
fi

exit $exit_code
