#!/bin/bash


input="$1"

if [[ "$input" =~ ^-?[0-9]+(\.[0-9]+)?$ ]];
then
    echo "Error: is number"
    exit 1
fi

if [[ "$#" -ne 1 ]];
then
    echo "Error: function can take one argument"
    exit 1
else
    echo "Input string: $input"
fi



