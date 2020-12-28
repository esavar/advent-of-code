#!/bin/bash

x=0
y=0
head="E"

move() {
  direction=${1:-""}
  steps=${2:-""}

  case "$direction" in
    N)
      ((y+=steps))
      ;;
    E)
      ((x+=steps))
      ;;
    S)
      ((y-=steps))
      ;; 
    W)
      ((x-=steps))
      ;;
  esac
}

get_direction() {
  angle=${1:-""}
  turn=${2:-""}
  prev=${3:-""}

  ((turns=angle%360/90))
  case "$prev" in
    N)
      course=0
      ;;
    E)
      course=1
      ;;
    S)
      course=2
      ;; 
    W)
      course=3
      ;;
  esac

  case "$turn" in 
    R)
      ((course+=turns))
      ;;
    L)
      ((course-=turns))
      ;;
  esac

  ((course%=4))
  if [[ "$course" -lt 0 ]]; then
    ((course+=4))
  fi
  case "$course" in
    0)
      head="N"
      ;;
    1)
      head="E"
      ;;
    2)
      head="S"
      ;;
    3)
      head="W"
      ;;
  esac
}

while read -r input; do
  count=$(tr -d -c 0-9 <<<"$input")
  dir=$(echo "$input" | head -c1)
  case "$dir" in
    N)
      move "N" "$count"
      ;;
    E)
      move "E" "$count"
      ;;
    S)
      move "S" "$count"
      ;; 
    W)
      move "W" "$count"
      ;;
    F)
      move "$head" "$count"
      ;;
    R)
      get_direction "$count" "R" "$head" 
      ;;
    L)
      get_direction "$count" "L" "$head" 
      ;;
  esac
  echo "$dir $head $count $x $y"
done <input.txt

sign () { echo "$(( $1 < 0 ? -1 : 1 ))"; }
absolute_value() {
  val=${1:-""}
  echo "$(( val * $(sign "$val") ))"  
}

echo $(( $(absolute_value "$x") + $(absolute_value "$y") ))
