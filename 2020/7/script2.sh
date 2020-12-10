#!/bin/bash

get_insides() {
  containercolor=${1:-""}
  parsed=$(sed -n "s/^$containercolor bags contain \(.*\)/\1/p" input.txt)
  echo "$parsed"
}

get_color() {
  insider=${1:-""}
  insidercolor=$(sed -n "s/[0-9] \(.*\) bag.*/\1/p" <<<"$insider") 
  echo "$insidercolor"
}

search_bags() {
  searchcolor=${1:-""}

  insides=$(get_insides "$searchcolor")
  if [[ $insides =~ "no other bag" ]]; then
    echo 0
    return
  fi

  insidesarr=()
  IFS="," read -r -a insidesarr <<<"$insides"

  totalsum=0
  for (( i=0; i<${#insidesarr[@]}; i++ )); do
    count=$(tr -d -c 0-9 <<<"${insidesarr[@]:$i:1}")
    color=$(get_color "${insidesarr[@]:$i:1}" | xargs)
    newinsides=$(search_bags "$color")
    if [[ $newinsides -eq 0 ]]; then
      ((totalsum+=count))
    else 
      ((totalsum=totalsum+count*newinsides+count))
    fi
  done
  echo "$totalsum"
}

sum=$(search_bags "shiny gold")
echo "Part 2: $sum"
