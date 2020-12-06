#!/bin/bash

part1() {
  while read -r p; do
    while read -r q; do
      if [[ $((q+p)) -eq 2020 ]] ; then
        ((part1=q*p))
        echo "Part 1: $q * $p is $part1"
        return
      fi
    done <input.txt
  done <input.txt
}

part2() {
  while read -r p; do
    while read -r q; do
      while read -r r; do
        if [[ $((q+p+r)) -eq 2020 ]] ; then
          ((part2=q*p*r))
          echo "Part 2: $q * $p * $r is $part2"
          return
        fi
      done <input.txt
    done <input.txt
  done <input.txt
}

part1
part2
