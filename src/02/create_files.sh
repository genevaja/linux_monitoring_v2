#!/bin/bash

. ./add_fn.sh

# Меняем некорректный формат на корректный
size=$(echo $3 | sed 's/Mb/MB/')

# Выбираем текущую дату и убираем лишние слеши
script_date=$(echo "_$(date +%D_%H_%M)" | sed 's/\///g')

delimeter="."
delimeter2="/"

# Расширение из 2 параметра в виде строки
extention=$(extract_ext $2)

folder_name=$1

# Максимальное количество символов в комбинации
max_char=$((250 - $(expr length "$extention") - $(expr length "$script_date")))

# DELETE THIS VAR!!!
qty_folders=$2

# Количество символов в части имени для названия файлов
name_char_qty=$(expr length "$(extract_file_name $2)")
# Извлечённая часть названия файла без расширения
start_file_name=$(extract_file_name $2)

# Количество символов в аргументе с буквами для названия папок
char_qty=$(expr length "$1")

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

function generate_number () {
  local number=$RANDOM
  let "number %= $1"
  echo $number
}


function create_files () {
  current_path=$(pwd)
  
  # Составляем список с доступными папками
  list_folder /

  # Инициализируем стартовое количество строк в файле
  search_qty_res=$(wc -l $current_path/result.txt | awk '{print $1}')


  # Генерируем название для создаваемой папки
  fold_name=$(generate_folder_name $1)$script_date


  while [[ 1 ]]
  do
    # Генерируем случайно число для строки из файла
    # Если сгенерированное число = 0, запускаем цикл повторно
    number=$(generate_number $search_qty_res)
    if [[ $number == 0 ]]; then
      continue
    fi
    # Извлекаем строку с расположением доступной папки из файла 
    string=$(head -$number $current_path/result.txt | tail +$number)
    # Удаляем обработанную строку из файла
    sed -i ${number}d ./result.txt
    # Создаём папку
    created_folder="$string$delimeter2$fold_name"
    if [ ! -d $created_folder ]; then
      mkdir $created_folder 2>/dev/null
    else
      continue
    fi
    if [[ $? -eq 0 ]]; then
      log_str=$created_folder" "$(date +%D_%H_%M)" ""0"
      echo $log_str >> $current_path/log.txt
    fi

    # Обнуляем счётчик для сгенерированных имён файлоа
    reset_counter
    # Генерируем случайный номер для количества файлов
    file_qty=$(awk -v min=1 -v max=100 'BEGIN{srand(); print int(min+rand()*(max-min+r))}')

    # Цикл для создания файлов
    for (( z=0; z < $file_qty; z++ ))
    do
      check_space
      if [[ $? -eq 0 ]]; then
        file_name=""
        generate_name ${counter[*]}
        file_name=$file_name$delimeter$extention$script_date
        head -c $size /dev/zero > $created_folder/$file_name 2>/dev/null
        # Делаем запись в логе
        if [[ $? -eq 0 ]]; then
          log_str=$created_folder"/"$file_name" "$(date +%D_%H_%M)" "$size
          echo $log_str >> $current_path/log.txt
        fi
      else
        >&2 echo "Space exhausted"
        return 0
      fi
    done
    # Обновляем количество папок в файле
    search_qty_res=$(wc -l $current_path/result.txt | awk '{print $1}')
    # Если файл исчерпан, обновляем список с папками
    if [[ $search_qty_res == 5 ]]; then
      list_folder /
    fi
  done
}
