#!/bin/bash

sum1=0
data1=()
sum2=0
data2=()
while read -r input; do
  if [[ $input = "" ]]; then
    ((sum1+=${#data1[@]}))
    for (( i=0; i<${#data1[@]}; i++ )); do
      if [[ $(grep -o "${data1[$i]}" <<<"${data2[*]}" | grep -c .) = "${#data2[@]}" ]]; then
        # echo "all answered yes to ${data1[$i]} in ${data2[*]}"
        ((sum2++))
      fi
    done
    # echo "starting new input"
    data1=()
    data2=()
    continue
  fi
  for (( i=0; i<${#input}; i++ )); do
    if [[ ! "${data1[*]}" =~ ${input:$i:1} ]]; then
      data1+=("${input:$i:1}")
    fi
  done
  data2+=("$input")
done <input.txt

echo "Part 1: $sum1"
echo "Part 2: $sum2"
