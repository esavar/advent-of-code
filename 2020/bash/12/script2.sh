#!/bin/bash

sign () { echo "$(( $1 < 0 ? -1 : 1 ))"; }
absolute_value() {
  val=${1:-""}
  echo "$(( val * $(sign "$val") ))"  
}

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

headx='E'
wpx=10
heady='N'
wpy=1
while read -r input; do
  count=$(tr -d -c 0-9 <<<"$input")
  dir=$(echo "$input" | head -c1)
  case "$dir" in
    N)
      if [[ "$heady" = 'S' ]]; then
        ((wpy-=count))
      else
        ((wpy+=count))
      fi
      if [[ "$wpy" -lt 0 ]]; then
        absy=$(absolute_value "$wpy")
        heady='N'
        wpy=$absy
      fi
      ;;
    E)
      if [[ "$headx" = 'W' ]]; then
        ((wpx-=count))
      else
        ((wpx+=count))
      fi
      if [[ "$wpx" -lt 0 ]]; then
        absx=$(absolute_value "$wpx")
        headx='E'
        wpx=$absx
      fi
      ;;
    S)
      if [[ "$heady" = 'N' ]]; then
        ((wpy-=count))
      else
        ((wpy+=count))
      fi
      if [[ "$wpy" -lt 0 ]]; then
        absy=$(absolute_value "$wpy")
        heady='S'
        wpy=$absy
      fi
      ;; 
    W)
      if [[ "$headx" = 'E' ]]; then
        ((wpx-=count))
      else
        ((wpx+=count))
      fi
      if [[ "$wpx" -lt 0 ]]; then
        absx=$(absolute_value "$wpx")
        headx='W'
        wpx=$absx
      fi
      ;;
    F)
      ((movex=count*wpx))
      ((movey=count*wpy))
      move "$heady" "$movey"
      move "$headx" "$movex"
      ;;
    R)
      get_direction "$count" "R" "$headx" 
      headx=$head
      get_direction "$count" "R" "$heady" 
      heady=$head
      if [[ $headx = 'N' || $headx = 'S' ]]; then
        tempy=$heady
        tempwpy=$wpy
        heady=$headx
        wpy=$wpx
        headx=$tempy
        wpx=$tempwpy
      fi
      ;;
    L)
      get_direction "$count" "L" "$headx" 
      headx=$head
      get_direction "$count" "L" "$heady" 
      heady=$head
      if [[ $headx = 'N' || $headx = 'S' ]]; then
        tempy=$heady
        tempwpy=$wpy
        heady=$headx
        wpy=$wpx
        headx=$tempy
        wpx=$tempwpy
      fi
      ;;
  esac
  echo "$dir $count $headx $wpx $heady $wpy $x $y"
done <input.txt

echo $(( $(absolute_value "$x") + $(absolute_value "$y") ))
