#!/bin/bash

if [[ "$1" == "mount" ]]; then
  mount -t ext3 -o loop /userdisk.fs /home/albert/D4/src_result
elif [[ "$1" == "umount" ]]; then
  umount /userdisk.fs
fi
