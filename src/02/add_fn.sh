#!/bin/bash

function summ_arr () {
  # Объявляем локальный массив
  local newarray
  # Собираем массив из переданных аргументов
  local_array=("$@")
  local result=0
  # Складываем элементы массива
  for j in "${local_array[@]}"
  do
    result=$(($result + $j ))
  done
  # Возвращаем результат
  if [[ "$result" -gt 255 ]]; then
    result=0
  fi
  return $result
}

function add_one () {
  i=0
  for (( ; i<$#; i++ ))
  do
    summ_arr ${counter[*]}
    local result=$?
    if [[ $result -lt $max_char ]]; then
      temp=$((${counter[$i]} + 1))
      counter[$i]=$temp
      break
    else
      counter[$i]=1
      continue
    fi
  done
  # Если сумма чисел меньше 4, повторить функцию
  if [[ $result < 3 ]]; then
  for (( ; i<$#; i++ ))
  do
    summ_arr ${counter[*]}
    local result=$?
    if [[ $result -lt $max_char ]]; then
      temp=$((${counter[$i]} + 1))
      counter[$i]=$temp
      break
    else
      counter[$i]=1
      continue
    fi
  done
  fi
  if [[ $(($i + 1)) -eq $# && $result -eq $(($max_char - 1)) ]];then
    >&2 echo "Namespace exhausted. Use more letters for name"
    return 1
  fi
  return 0
}

function extract_ext () {
  # Определяем общую длину аргумента
  local str_length=$(expr length "$1")
  # Определяем количество знаков до точки
  local before_dot=$( expr match "$1" '.*[.]' - 1)
  # Определяем количество знаков после точки
  local after_dot=$(expr length "$1" - $before_dot - 1)

  # Заполняем временный массив элементами после точки
  local temp_str2=""
  for (( i=$before_dot+1; i < $str_length; i++ ))
  do
    temp_str2+=$(echo ${1:$i:1})
  done

  # Возвращаем массив
  echo $temp_str2
}

function extract_file_name () {
  local str_length=$(expr length "$1")
  local before_dot=$( expr match "$1" '.*[.]' - 1)
  local temp_str=""
  for (( i=0; i < $before_dot; i++ ))
  do
    temp_str+=$(echo ${1:$i:1})
  done
  echo $temp_str
}

function generate_folder_name () {
  local fold_length=$(expr length $1)
  local temp_fold_name=""
  local add_char=$((4 - $fold_length))

  if [[ $fold_length -lt 4 ]]; then
    for (( i=0; i<$add_char; i++ ))
    do
      temp_fold_name=$temp_fold_name${1:0:1}
    done
    temp_fold_name=$temp_fold_name$1
  else
    temp_fold_name=$1
  fi
  
  echo $temp_fold_name
}

function generate_name () {
    add_one ${counter[*]}
    if [[ $? -eq 0 ]]; then
      local file_name_temp=""
      for (( j=0; j<$name_char_qty; j++ ))
      do
        for (( x=0; x < ${counter[$j]}; x++ ))
        do
          file_name_temp=$file_name_temp$(printf "%c" ${start_file_name:$j:1})
        done
      done
      file_name=$(printf "%s" $file_name_temp)
    else
      return
    fi
}

function list_folder () {
  local current_path=$(pwd)
  local my_name=$(whoami)
  # Ищем папки, принадлежащих группе $(whoami), исключая папки, которые содержат
  # bin и sbin и proc (папка с процессами), c разрешением 775 (права на чтение, и запись)
  find $1 -type d -not -path "*bin*" -not -path "*sbin*" -not -path "*proc*" -perm 775 -print 2>/dev/null 1> $current_path/result.txt
}
