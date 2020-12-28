#!/bin/bash

read_instuctions() {
  sum=0
  linecount=$(wc -l <input.txt)
  i=1
  cp /dev/null readlines_temp
  while true; do
    if [[ $i -eq $linecount ]]; then
      # echo $linecount
      echo "Part 2: $sum"
      return
    elif grep -q ^$i$ readlines_temp; then
      echo "LOOP"
      return
    else
      echo "$i" >> readlines_temp
    fi
    line=$(sed -n "$i p" input_temp)
    IFS=" " read -r cmd signedcount <<<"$line"
    count=$(tr -d -c 0-9 <<<"$signedcount")
    sign=${signedcount:0:1}
    case "$cmd" in
      acc) 
        case "$sign" in 
          +)
            ((sum+=count))
            ;;
          -)
            ((sum-=count))
            ;;
        esac
        ((i++))
        ;;
      jmp)
        case "$sign" in 
          +)
            ((i+=count))
            ;;
          -)
            ((i-=count))
            ;;
        esac
        ;;
      nop)
        ((i++))
        ;;
    esac
  done
}

swap() {
  from=${1:-""}
  to=${2:-""}

  froms=$(grep -n "$from" input.txt | cut -d":" -f1)
  for linenum in $froms; do
    cat input.txt > input_temp
    sed -i -e "$linenum s/$from/$to/" input_temp
    # echo "Line: $linenum"
    res=$(read_instuctions)
    if [[ ! $res = 'LOOP' ]]; then
      echo "Succeeded with replacing $from to $to in line $linenum"
      echo "$res"
      exit 0
    fi 
  done
}

swap "nop" "jmp"
swap "jmp" "nop"
