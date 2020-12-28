#!/bin/bash

ones=0
threes=0
sort -n input.txt > sorted_input_temp

len=$(wc -l <sorted_input_temp)
higest=$(tail -n 1 <sorted_input_temp)
((max=higest+3))
current=0
newones=0
options=1
for ((i=0; i<=len; i++)); do
  current=$(sed -n "$i p" sorted_input_temp)
  ((nextline=i+1))
  next=$(sed -n "$nextline p" sorted_input_temp)
  if [[ $nextline -gt $len ]]; then
    next=$max
  fi
  #echo $current $next
  ((substraction=next-current))
  if [[ $substraction -eq 1 ]]; then
    ((ones++))
    ((newones++))
  elif [[ $substraction -eq 3 ]]; then
    # echo "Rows of one: $newones"
    if [[ $newones -eq 2 ]] ; then
      # Row of two means only one can be toggled being connected or not 2^1
      ((options*=2))
    elif [[ $newones -eq 3 ]]; then
      # Row of three means two can be toggled
      ((options*=2*2))
    elif [[ $newones -eq 4 ]] ; then
      # One of the 4 needs to be connected in order to maintain max of three difference
      # Four was the maximum subsequent connections of one
      ((options*=2*2*2-1))
    fi
    ((threes++))
    newones=0
  fi
done

((result=ones*threes))
echo "Part 1: $result ($ones * $threes)"
echo "Part 2: $options"
