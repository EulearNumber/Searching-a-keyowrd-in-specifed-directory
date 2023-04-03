#!/bin/bash

function findAndCopy {
  local directory="$1"
  local keyword="$2"
  if grep -qr "$keyword" "$directory"; then
    mkdir -p Found
    index=1
    for file in $(grep -rl "$keyword" "$directory"); do
      cp -f "$file" Found/found_"$(basename "$file")"
      ((index++))
    done
    echo "Files were copied to the Found directory!"
    ls Found
  else
    echo "Keyword not found in any files!"
    return 1
  fi
}
function showDetails {
 touch Found/modification_details.txt
 local folder="$1"
 local index=1
 for file in "$folder"/*
 do
  echo "File "$index": $(basename "$file"): $(basename "$file") was modified by $(stat -c %U "$file") on  $(date -d "$(stat -c %x "$file")" '+%B %d, %Y at %H.%M')."
  echo "File "$index": $(basename "$file"): $(basename "$file") was modified by $(stat -c %U "$file") on  $(date -d "$(stat -c %x "$file")" '+%B %d, %Y at %H.%M')." >> Found/modification_details.txt
  ((index++))
 done
 }
echo "Enter the directory to search: "
read directory
directoryPath=$(find $HOME -type d -name "$directory")
if [[ ! -d "$directoryPath" ]]; then
   echo "$directory is not a valid directory."
   exit 1
fi
echo "Enter the keyword to search for: "
read keyword
if findAndCopy "$directoryPath" "$keyword"; then
  showDetails "./Found"
fi



