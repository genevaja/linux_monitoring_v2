#!/bin/bash

. ./add_fn.sh


# Меняем некорректный формат на корректный
size=$(echo $6 | sed 's/kb/KB/')

# Выбираем текущую дату и убираем лишние слеши
script_date=$(echo "_$(date +%D)" | sed 's/\///g')

delimeter="."

# Расширение из 5 параметра в виде строки
extention=$(extract_ext $5)

folder_name=$3

# Максимальное количество символов в комбинации
max_char=$((250 - $(expr length "$extention") - $(expr length "$script_date")))

qty_folders=$2

# Количество символов в части имени для названия файлов
name_char_qty=$(expr length "$(extract_file_name $5)")
# Извлечённая часть названия файла без расширения
start_file_name=$(extract_file_name $5)

# Количество символов в аргументе с буквами для названия папок
char_qty=$(expr length "$3")

# Объявляем массим для счётчика для каждого элемента
declare -a counter

# Выставляем стартовые значения для массива в 1
function reset_counter () {
  for (( i=0; i<$name_char_qty; i++ ))
  do
    counter[$i]=1
  done
}



function check_space () {
  float2='1.0'
  df_res=$(df -h / | awk 'NR == 2{print $4}')
  expr_res=$(expr length "$df_res")
  if [[ "${df_res:$(expr length "$df_res") - 1:1}" == 'M' ]]; then
    df_res=$(echo $(echo $df_res | tr -d M ))
    df_res=$(bc<<<"scale=3;$df_res/1000")
  fi
  df_res=$(echo $(echo $df_res | tr -d G | tr , .))
  if [[ $(echo "$df_res >= $float2" | bc) -eq 1 ]]; then
    return 0
  else
    return 1
  fi
}


function create_files () {
  current_path=$(pwd)
  cd $1
  fold_name=$(generate_folder_name $3)$script_date

  log_str=""
  for (( f=0; f < $2; f++ ))
  do
    mkdir $fold_name
    log_str=$(pwd)"/"$fold_name" "$(date +%D)" ""0"
    echo $log_str >> $current_path/log.txt
    cd $fold_name
    
    reset_counter
    # Цикл для создания файлов
    for (( z=0; z < $4; z++ ))
    do
      check_space
      if [[ $? -eq 0 ]]; then
        file_name=""
        generate_name ${counter[*]}
        file_name=$file_name$delimeter$extention$script_date
        head -c $size /dev/zero > $file_name 2>/dev/null
        # Делаем запись в логе
        log_str=$(pwd)"/"$file_name" "$(date +%D)" "$size
        echo $log_str >> $current_path/log.txt
      else
        >&2 echo "Space exhausted"
        return 1
      fi
    done
  done
  return 0
}
