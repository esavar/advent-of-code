#!/bin/bash

sum1=0
sum2=0
while read -r i; do
  IFS=" " read -r nrange testchar str <<<"$i"
  IFS="-" read -r n1 n2 <<<"$nrange"
  IFS=":" read -r char <<<"$testchar"
  c1=$(echo "$str" | head -c "$n1" | tail -c 1)
  c2=$(echo "$str" | head -c "$n2" | tail -c 1)
  count=$(grep -o "$char" <<<"$str" | grep -c .)
  if [[ $count -le "$n2" && $count -ge "$n1" ]] ; then
    ((sum1++))
  fi
  if [[ ($char = "$c1" && ! ( $char = "$c2" )) || ($char = "$c2" && ! ( $char = "$c1" )) ]] ; then
    ((sum2++))
  fi
done <input.txt

echo "Part 1: $sum1"
echo "Part 2: $sum2"
