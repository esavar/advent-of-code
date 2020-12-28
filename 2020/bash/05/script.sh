#!/bin/bash

get_seat() {
  input=${1:-""}
  min=${2:-""}
  max=${3:-""}

  if [[ $min -eq $max ]]; then
    echo "$min"
    return
  fi

  len=${#input}
  current=$(echo "$input" | head -c1)
  rest=$(echo "$input" | cut -c2-"$len")
  ((breakpoint=(max-min)/2+min))

  if [[ $current = 'F' || $current = 'L' ]] ; then
    get_seat "$rest" "$min" "$breakpoint"
  elif [[ $current = 'B' || $current = 'R' ]]; then
    ((min=breakpoint+1))
    get_seat "$rest" "$min" "$max"
  else
    echo 'invalid input'
  fi
}

get_seat_id() {
  input=${1:-""}
  
  rows=$(echo "$input" | head -c7)
  row=$(get_seat "$rows" 0 127)
  cols=$(echo "$input" | cut -c8-10)
  col=$(get_seat "$cols" 0 7)
  
  ((result=row*8+col))
  echo "$result"
}

cp /dev/null takenseats_temp
higest=0
while read -r i; do
  result=$(get_seat_id "$i")
  echo "$result" >>takenseats_temp
done <input.txt

sort -n <takenseats_temp >sortedtakenseats_temp
higest=$(tail -n1 sortedtakenseats_temp)
echo "higest $higest"

for s in $(seq "$(head -n1 <sortedtakenseats_temp)" "$higest"); do
  if grep  -q "$s" sortedtakenseats_temp; then
    continue
  fi
  availableseat=$s
  break
done
echo "my seat $availableseat"
