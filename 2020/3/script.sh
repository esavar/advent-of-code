#!/bin/bash

encountered_tree() {
  xpos=${1:-""}
  row=${2:-""}
  mark=$(echo "$row" | head -c "$xpos" | tail -c 1)
  if [[ $mark = '#' ]]; then
    echo true
  else
    echo false
  fi
}

get_tree_count() {
  x=1
  sum=0
  counter=0
  firstrow=true
  
  addx=${1:-""}
  addy=${2:-""}
  
  while read -r i; do
    if [[ $firstrow = true ]] ; then
      firstrow=false
      len=${#i}
      continue
    fi
    ((counter++))
    if [[ ! ( $addy -eq 1 ) && ! ( $((counter % addy)) -eq 0 ) ]]; then
      # echo "passed redundant row"
      continue
    fi
    ((x=addx*counter%len+1)) # col indexing starts from 1
    if [[ $(encountered_tree "$x" "$i") = true ]]; then
      # echo "row $counter had tree at pos $x"
      ((sum++))
    fi
  done <input.txt
  echo "$sum"
}

get_tree_count 3 1 # Part 1
( get_tree_count 1 1 ; get_tree_count 3 1 ; get_tree_count 5 1 ; get_tree_count 7 1 ; get_tree_count 1 2) | xargs echo | sed 's/ /*/g' | bc # Part 2
