#!/bin/bash

abs() { 
  echo $(( $1 * (($1>0) - ($1<0)) ))
}

mean() {
  count=0
  sum=0;
  for int in "${@}"
    do
    ((sum += int))
    ((count += 1))
  done
  echo $(expr $sum / $count)
}

median() {
  arr=($(printf '%d\n' "${@}" | sort -n))
  nel=${#arr[@]}
  if (( $nel % 2 == 1 )); then
    med="${arr[ $(($nel/2)) ]}"
  else
    (( j=nel/2 ))
    (( k=j-1 ))
    (( med=(${arr[j]} + ${arr[k]})/2 ))
  fi
  echo "$med"
}

fuel_consumption() {
  fuel=0
  if [[ $2 = "constant_growth" ]]
  then
    for i in "${@:3}"; do
      let fuel+=$(abs $(expr $i - $1))
    done
  else
    for i in "${@:3}"; do
      # delta * (delta + 1) / 2
      delta=$(abs $(expr $i - $1))
      let fuel+=$(expr $delta \* $(expr $delta + 1) / 2)
    done
  fi
  echo $fuel
}

input=$(cat ./input.txt | tr , "\n" | sort -t',' -n)
median=$(median $input)

echo "median ($median) fuel consumption:"
fuel_consumption $median constant_growth $input 

mean=$(mean $input)

echo "mean ($mean) fuel consumption:"
fuel_consumption $mean exponential_growth $input 


