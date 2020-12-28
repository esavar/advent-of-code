#!/bin/bash

start=0
current=26
cp /dev/null calculated_temp

init() {
  for ((i=1; i<25; i++)); do
    ((ilinenum=start+i))
    iline=$(sed -n "$ilinenum p" input.txt)
    sumrow=""
    for ((j=i+1; j<26; j++)); do
      ((jlinenum=start+j))
      jline=$(sed -n "$jlinenum p" input.txt)
      ((sum=iline+jline))
      sumrow="$sumrow $sum"
    done
    echo "$sumrow" >> calculated_temp
  done
}

init

while true; do
  ((start++))
  cp calculated_temp calculated_temp_temp
  currentline=$(sed -n "$current p" input.txt)
  if ! grep -q "\b$currentline\b" calculated_temp; then
    echo "Part 1: $currentline on line $current"
    exit 0
  fi
  ((current++))
  cp /dev/null calculated_temp_temp
  for ((i=1; i<25; i++)); do
    ((ilinenum=start+i))
    iline=$(sed -n "$ilinenum p" input.txt)
    ((sum=iline+currentline))
    ((x=i+1))
    sumrow=$(sed -n "$x p" calculated_temp)
    sumrow="$sumrow $sum"
    echo "$sumrow" >> calculated_temp_temp
  done
  cp calculated_temp_temp calculated_temp
done
