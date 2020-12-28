#!/bin/bash

free=false
skip=false
count=0
seat_free() {
  xpos=${1:-""}
  currentrow=${2:-""}
  current=${3:-""}

  ((x=xpos+1))
  count=0
  marks=$(echo "$currentrow" | head -c "$x" | tail -c 3)
  mark=$(echo "$currentrow" | head -c "$xpos" | tail -c 1)
  if [[ ! $mark =~ '#' && $current = "true" ]]; then
    free=true
    if [[ $mark = '.' ]]; then
      skip=true
    else
      skip=false
    fi
    count=$(grep -o "#" <<<"$marks" | grep -c .)
  else
    free=false
    skip=false
    count=$(grep -o "#" <<<"$marks" | grep -c .)
    if [[ $current = "true" && $mark = '#' ]]; then
      ((count-=1))
    fi
  fi
}

iterate() { 
  len=${1:-""}
  hgt=${2:-""}
  
  prevrow=""
  for ((i=1; i<=hgt; i++)); do
    row=$(sed -n "$i p" input_temp)
    ((next=i+1))
    nextrow=$(sed -n "$next p" input_temp)
    for ((j=1; j<=len; j++)); do
      seat_free "$j" "$row" "true"
      if [[ $free = true ]]; then
        if [[ $skip = true || ! $count -eq 0 ]]; then
          continue
        fi
        seat_free "$j" "$prevrow" false
        if [[ $count -eq 0 ]]; then
          seat_free "$j" "$nextrow" false
          if [[ $count -eq 0 ]]; then
            ((charsbefore=j-1))
            # echo "CHANGING TO TAKEN pos $charsbefore +1 at row $i"
            sed -i -e "$i s/\(.\{$charsbefore\}\)L/\1#/" input_temp_temp
          fi
        fi
      else
        ((takencount=count))
        seat_free "$j" "$prevrow" false
        ((takencount=takencount+count))
        seat_free "$j" "$nextrow" false
        ((takencount+=count))
        if [[ $takencount -ge 4 ]]; then
          ((charsbefore=j-1))
          # echo "CHANGING pos $charsbefore +1 at row $i"
          sed -i -e "$i s/\(.\{$charsbefore\}\)#/\1L/" input_temp_temp
        fi
      fi
    done
    prevrow=$row
  done
}

len=$(head -n 1 <input.txt | wc -m)
hgt=$(wc -l <input.txt)
cp input.txt input_temp
cp input_temp input_temp_temp
while true; do
  iterate "$len" "$hgt"
  ((counteriter++))
  sum=$(grep -o "#" <input_temp_temp | grep -c .)
  echo "iterating $counteriter, sum now $sum"
  diff=$(comm -3 input_temp_temp input_temp | wc -l | xargs)
  echo "diff $diff"
  if [[ $diff -eq 0 ]]; then
    sum=$(grep -o "#" <input_temp_temp | grep -c .)
    echo "Part 1: $sum"
    exit 0
  fi
  cp input_temp_temp input_temp
done