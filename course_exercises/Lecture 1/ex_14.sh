#!/bin/bash
text=$(cat ex_14_data.txt | sed --expression='s/e/E/g')
only_a="${text//[^a]}"
echo $text > ex_14_data_new.txt
echo "Number of letter a is ${#only_a}"
