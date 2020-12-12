#!/bin/bash

sum=0
i=1
cp /dev/null readlines_temp
while true; do
  if grep -q ^$i$ readlines_temp; then
    echo "Part 1: $sum"
    exit 0
  else
    echo "$i" >> readlines_temp
  fi
  line=$(sed -n "$i p" input.txt)
  # echo "$line $i"
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
