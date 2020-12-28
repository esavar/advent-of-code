#!/bin/bash

is_valid() {
  input=${1:-""}
  if [[
    $input =~ byr:(19[2-9][0-9]|200[0-2])((\ |\s)|$)
    && $input =~ iyr:20(1[0-9]|20)((\ |\s)|$)
    && $input =~ eyr:20(2[0-9]|30)((\ |\s)|$)
    && $input =~ hgt:(1([5-8][0-9]|9[0-3])cm|(59|6[0-9]|7[0-6])in)((\ |\s)|$)
    && $input =~ hcl:\#[0-9a-f]{6}((\ |\s)|$)
    && $input =~ ecl:(amb|blu|brn|gry|grn|hzl|oth)((\ |\s)|$)
    && $input =~ pid:[0-9]{9}((\ |\s)|$)
  ]]; then    
    echo true
    return
  fi
  echo false
}

has_required_fields() {
  input=${1:-""}
  if [[
    $input =~ byr:[^\s]
    && $input =~ iyr:[^\s]
    && $input =~ eyr:[^\s]
    && $input =~ hgt:[^\s] 
    && $input =~ hcl:[^\s] 
    && $input =~ ecl:[^\s] 
    && $input =~ pid:[^\s]
  ]] ; then
    echo true
    return
  fi
  echo false
}

sum1=0
sum2=0
datarow=""
while read -r i; do
  if [[ $i = "" ]]; then
    # echo "starting new input"
    datarow=""
  fi
  datarow="$datarow $i"
  if [[ $(has_required_fields "$datarow") = true ]] ; then
    if [[ $(is_valid "$datarow") = true ]] ; then
      # echo "all required input fields are valid $datarow"
      ((sum2++))
    fi
    datarow=""
    ((sum1++))
  fi
done <input.txt

echo "Part 1: $sum1"
echo "Part 2: $sum2"
