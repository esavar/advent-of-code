#!/bin/bash

cp /dev/null calculated_temp

magicnum=1309761972
row=0
calculation=0
while true; do
  if [[ $calculation -eq $magicnum ]]; then
    smallest=$(sort -n <calculated_temp | head -n 1)
    largest=$(sort -n <calculated_temp | tail -n 1)
    ((sum=smallest+largest))
    echo "Part 2: $sum produced from $smallest and $largest"
    exit 0
  elif [[ $calculation -le $magicnum ]]; then
    ((row++))
    currentline=$(sed -n "$row p" input.txt)
    ((calculation+=currentline))
    echo "$currentline" >> calculated_temp
  elif [[ $calculation -ge $magicnum ]]; then
    rowcount=$(wc -l <calculated_temp)
    ((calculationrows=rowcount-1))
    small=$(head -n 1 <calculated_temp)
    ((calculation-=small))
    tail -n "$calculationrows" <calculated_temp_temp >calculated_temp
  fi
  cp calculated_temp calculated_temp_temp
done
