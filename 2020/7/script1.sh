#!/bin/bash

get_colors() {
  color=${1:-""}
  containers=$(sed -n "s/\(.*\) bags contain.*$color.*/\1/p" input.txt)
  echo "$containers"
}

doit=true
get_colors "shiny gold" | sort | uniq >sorted_bags_temp
cp sorted_bags_temp sorted_all_bags_temp
while [[ $doit = true ]]; do

  cp /dev/null acc_bags_temp
  while read -r bag; do
   get_colors "$bag" >>acc_bags_temp
  done <sorted_bags_temp

  sort <acc_bags_temp | uniq >sorted_acc_bags_temp
  comm -13 sorted_all_bags_temp sorted_acc_bags_temp | sed '/^[[:space:]]*$/d' >sorted_new_bags_temp

  cat sorted_new_bags_temp
  cp sorted_new_bags_temp sorted_bags_temp
  if ! grep -q '[^[:space:]]' sorted_new_bags_temp; then
    doit=false
  fi

  cp sorted_all_bags_temp all_bags_temp
  cat sorted_new_bags_temp >>all_bags_temp
  sort <all_bags_temp | uniq >sorted_all_bags_temp
done

wc -l <sorted_all_bags_temp | xargs echo "Part 1: "
