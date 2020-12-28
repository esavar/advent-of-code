#!/bin/bash

seat_free() {
  xpos=${1:-""}
  ypos=${2:-""}
  free=false

  mark=$(sed -n "$ypos p" input_temp | head -c "$xpos" | tail -c 1)
  if [[ $mark =~ 'L' ]]; then
    free=true
  fi
}

iterate() { 
  nbhoods=${1:-""}
  
  for ((i=1; i<=nbhoods; i++)); do
    row=$(sed -n "$i p" neighborhoods_temp)
    mex=""
    mey=""
    imfree=false
    takencount=0
    for neighbor in $row; do
      IFS=";" read -r x y <<<"$neighbor"
      if [[ $mex = "" ]]; then
        mex=$x
        mey=$y
        seat_free "$x" "$y"
        if [[ $free = true ]]; then
          imfree=true
        fi
        continue
      fi
      seat_free "$x" "$y"
      if [[ $free = false ]]; then
        ((takencount++))
      fi
    done

    if [[ $takencount -eq 0 && $imfree = true ]]; then
      ((charsbefore=mex-1))
      # echo "CHANGING TO TAKEN pos $charsbefore +1 at row $mey"
      sed -i -e "$mey s/\(.\{$charsbefore\}\)L/\1#/" input_temp_temp
    elif [[ $imfree = false && $takencount -ge 5 ]]; then
      ((charsbefore=mex-1))
      # echo "CHANGING pos $charsbefore +1 at row $mey"
      sed -i -e "$mey s/\(.\{$charsbefore\}\)#/\1L/" input_temp_temp
    fi
  done
}

len=$(head -n 1 <input.txt | wc -m)
hgt=$(wc -l <input.txt)

get_neighbor_index() {
  idxx=${1:-""}
  idxy=${2:-""}
  xdiff=${3:-""}
  ydiff=${4:-""}
  while true; do
    if [[ $idxy -le 0 || $idxx -le 0 ]]; then
      # end of input
      nghbridx=""
      return
    fi
    nghbr=$(sed -n "$idxy p" input.txt | head -c "$idxx" | tail -c 1)
    if [[ $nghbr = 'L' || $nghbr = '#' ]]; then
      nghbridx="$idxx;$idxy"
      return
    elif [[ $nghbr = '.' ]]; then
      ((idxx+=xdiff))
      ((idxy+=ydiff))
    else
      # end of input
      nghbridx=""
      return
    fi
  done
}

init_neighbors() {
  cp /dev/null neighborhoods_temp
  for irow in $(seq 1 "$hgt"); do
    for icol in $(seq 1 "$len"); do
      hoods=""

      if [[ $(sed -n "$irow p" input.txt | head -c "$icol" | tail -c 1) = "." ]] ; then
        continue
      fi

      # top neighbor
      ((toplefty=irow-1))
      ((topleftx=icol-1))
      if [[ $irow -gt 1 ]]; then
        if [[ $icol -gt 1 ]]; then
          get_neighbor_index "$topleftx" "$toplefty" "-1" "-1"
          if [[ ! $nghbridx = "" ]]; then
            hoods+=" $nghbridx"
          fi
        fi
        ((topy=irow-1))
        ((topx=icol))
        get_neighbor_index "$topx" "$topy" "0" "-1"
        if [[ ! $nghbridx = "" ]]; then
          hoods+=" $nghbridx"
        fi
        ((toprighty=irow-1))
        ((toprightx=icol+1))
        get_neighbor_index "$toprightx" "$toprighty" "1" "-1"
        if [[ ! $nghbridx = "" ]]; then
          hoods+=" $nghbridx"
        fi
      fi

      # leftierightie neighbors
      if [[ $icol -gt 1 ]]; then
        ((leftx=icol-1))
        get_neighbor_index "$leftx" "$irow" "-1" "0"
        if [[ ! $nghbridx = "" ]]; then
          hoods+=" $nghbridx"
        fi
      fi
      ((rightx=icol+1))
      get_neighbor_index "$rightx" "$irow" "1" "0"
      if [[ ! $nghbridx = "" ]]; then
        hoods+=" $nghbridx"
      fi

      # bottom neighbors
      if [[ $icol -gt 1 ]]; then
        ((bottomlefty=irow+1))
        ((bottomleftx=icol-1))
        get_neighbor_index "$bottomleftx" "$bottomlefty" "-1" "1"
        if [[ ! $nghbridx = "" ]]; then
          hoods+=" $nghbridx"
        fi
      fi
      ((bottomy=irow+1))
      get_neighbor_index "$icol" "$bottomy" "0" "1"
      if [[ ! $nghbridx = "" ]]; then
        hoods+=" $nghbridx"
      fi
      ((bottomrighty=irow+1))
      ((bottomrightx=icol+1))
      get_neighbor_index "$bottomrightx" "$bottomrighty" "1" "1"
      if [[ ! $nghbridx = "" ]]; then
        hoods+=" $nghbridx"
      fi

      echo "$icol;$irow $hoods" >> neighborhoods_temp
    done
  done
}

init_neighbors

nbhhgt=$(wc -l <neighborhoods_temp)

cp input.txt input_temp
cp input_temp input_temp_temp
while true; do
  iterate "$nbhhgt"
  ((counteriter++))
  sum=$(grep -o "#" <input_temp_temp | grep -c .)
  echo "iterating $counteriter, sum now $sum"
  diff=$(comm -3 input_temp_temp input_temp | wc -l | xargs)
  echo "diff $diff"
  if [[ $diff -eq 0 ]]; then
    sum=$(grep -o "#" <input_temp_temp | grep -c .)
    echo "Part 2: $sum"
    exit 0
  fi
  cp input_temp_temp input_temp
done
