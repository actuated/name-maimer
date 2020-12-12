#!/bin/bash
#name-maimer.sh
dateCreated="12/10/2020"
dateLastMod="12/11/2020"

thisRandom=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | head -c 15 | cut -c1-15)
tempFile="temp-name-maimer-$thisRandom.txt"
outFile="name-maimer-$thisRandom.txt"
foundOutFormat="N"
isVerbose="N"
doFormatAll="N"
doMax="N"
needSeperator="N"
seperator=""
addBefore=""
addAfter=""

function fnUsage {
  echo
  echo "========================================[ about ]========================================"
  echo
  echo "Mangles usernames into specified formats."
  echo "Includes unmodified single string lines in output."
  echo "Converts 'first last' or 'last, first' to specified formats."
  echo
  echo "Created $dateCreated, last modified $dateLastMod."
  echo
  echo "========================================[ usage ]========================================"
  echo
  echo "./name-maimer.sh [input file] -f [value(s)] [-v]"
  echo
  echo "Example:                                   Turns 'john smith' or 'smith, john' into:"
  echo "--------                                   -----------------------------------------"
  echo "./name-maimer.sh names.txt -f ahl          jsmith, johns, smithj"
  echo "./name-maimer.sh names.txt -f b -s _       j_smith"
  echo "./name-maimer.sh names.txt -f a -b admin_  admin_jsmith"
  echo "./name-maimer.sh names.txt -f am -m 4      jsmi, smj[a-z]"
  echo
  echo "[input file]     Input file containing names. Must be first argument."
  echo
  echo "-f [value]       Specify format(s) to mangle first and last names."
  echo "                 Ex: -f abce"
  echo
  echo "-s [seperator]   Seperator for formats that require one."
  echo
  echo "-m [number]      Maximum length for converted names."
  echo "                 Does not apply to uncoverted single strings."
  echo "                 Does not apply to -b or -a additions."
  echo
  echo "-b [string]      Prepend string before generated names."
  echo
  echo "-a [string]      Append string after generated names."
  echo
  echo "-v               Verbose output, shows how each line is recognized and converted."
  echo "                 By default, output is only shown for rejected lines."
  echo
  echo "--list-formats   List mangling formats."
  echo
  echo "=========================================[ fin ]========================================="
  echo
  exit
}

function fnFormats {
  echo
  echo "=======================================[ formats ]======================================="
  echo
  echo "ALL"
  echo
  echo "~ = seperator, specified with -s [seperator]."
  echo "* = name that will be cut if -m sets a max length"
  echo
  echo "a - jsmith - [first initial][*last name*]"
  echo "b - j~smith - [first initial][seperator][*last name*] - requires seperator"
  echo "c - jxsmith - [first initial][generate a-z][*last name*]"
  echo "d - jxs - [first initial][generate a-z][last initial]"
  echo "e - john~smith - [first name][seperator][last name] - requires seperator"
  echo "f - johnsmith - [first name][last name]"
  echo "g - johnxsmith - [first name][generate a-z][last name]"
  echo "h - johns - [*first name*][last initial]"
  echo "i - johnxs - [*first name*][generate a-z][last initial]"
  echo "j - john - [*first name*]"
  echo "k - smith - [*last name*]"
  echo "l - smithj - [*last name*][first initial]"
  echo "m - smithjx - [*last name*][first initial][generate a-z]"
  echo
  echo "=========================================[ fin ]========================================="
  echo
  exit
}
echo
echo "======================[ name-maimer.sh - Ted R (github: actuated) ]======================"

# Set input file
nameFile=""
nameFile="$1"
shift

# Check input file
if [ "$nameFile" = "" ]; then
  echo
  echo "$(tput setaf 1)Error: Input file not given as first argument.$(tput sgr0)"
  fnUsage
elif [ "$nameFile" = "--list-formats" ]; then
  echo
  fnFormats
elif [ "$nameFile" = "-h" ]; then
  echo
  fnUsage
elif [ ! -f "$nameFile" ]; then
  echo
  echo "$(tput setaf 1)Error: '$nameFile' input file does not exist.$(tput sgr0)"
  fnUsage
fi

# Check options
while [ "$1" != "" ]; do
  case "$1" in
    -f )
      shift
      formatSet="$1"
      if [ "$formatSet" = "" ]; then
        echo
        echo "$(tput setaf 1)Error: Output name format(s) not specified.$(tput sgr0)"
        fnUsage
      else
        if [[ "$formatSet" == *"ALL"* ]]; then
          foundOutFormat="Y"
          doFormatAll="Y"
          needSeperator="Y"
        fi
        if [[ "$formatSet" == *"a"* ]]; then
          foundOutFormat="Y"
          doFormatA="Y"
        fi
        if [[ "$formatSet" == *"b"* ]]; then
          foundOutFormat="Y"
          doFormatB="Y"
          needSeperator="Y"
        fi
        if [[ "$formatSet" == *"c"* ]]; then
          foundOutFormat="Y"
          doFormatC="Y"
        fi
        if [[ "$formatSet" == *"d"* ]]; then
          foundOutFormat="Y"
          doFormatD="Y"
        fi
        if [[ "$formatSet" == *"e"* ]]; then
          foundOutFormat="Y"
          doFormatE="Y"
          needSeperator="Y"
        fi
        if [[ "$formatSet" == *"f"* ]]; then
          foundOutFormat="Y"
          doFormatF="Y"
        fi
        if [[ "$formatSet" == *"g"* ]]; then
          foundOutFormat="Y"
          doFormatG="Y"
        fi
        if [[ "$formatSet" == *"h"* ]]; then
          foundOutFormat="Y"
          doFormatH="Y"
        fi
        if [[ "$formatSet" == *"i"* ]]; then
          foundOutFormat="Y"
          doFormatI="Y"
        fi
        if [[ "$formatSet" == *"j"* ]]; then
          foundOutFormat="Y"
          doFormatJ="Y"
        fi
        if [[ "$formatSet" == *"k"* ]]; then
          foundOutFormat="Y"
          doFormatK="Y"
        fi
        if [[ "$formatSet" == *"l"* ]]; then
          foundOutFormat="Y"
          doFormatL="Y"
        fi
        if [[ "$formatSet" == *"m"* ]]; then
          foundOutFormat="Y"
          doFormatM="Y"
        fi
        if [[ "$formatSet" == *"n"* ]]; then
          foundOutFormat="Y"
          doFormatN="Y"
        fi
      fi
      ;;
    -s )
      shift
      seperator="$1"
      ;;
    -b )
      shift
      addBefore="$1"
      if [ "$addBefore" = "" ]; then
        echo
        echo "$(tput setaf 1)Error: -b used, but no string specified.$(tput sgr0)"
        fnUsage
      fi
      ;;
    -m )
      shift
      doMax="Y"
      maxLength="$1"
      if [[ ! "$maxLength" =~ ^[0-9]+$ ]]; then
        echo
        echo "$(tput setaf 1)Error: -m used, but '$maxLength' was not an integer.$(tput sgr0)"
        fnUsage
      fi
      ;;
    -a )
      shift
      addAfter="$1"
      if [ "$addAfter" = "" ]; then
        echo
        echo "$(tput setaf 1)Error: -a used, but no string specified.$(tput sgr0)"
        fnUsage
      fi
      ;;
    --list-formats )
      fnFormats
      ;;
    -v )
      isVerbose="Y"
      ;;
    * )
      fnUsage
      ;;
  esac
  shift
done

if [ "$needSeperator" = "Y" ] && [ "$seperator" = "" ]; then
  echo
  echo "$(tput setaf 1)Error: No seperator specified.$(tput sgr0)"
  fnUsage
fi

if [ "$foundOutFormat" = "N" ]; then
  echo
  echo "$(tput setaf 1)Error: Output name format(s) not specified.$(tput sgr0)"
  fnUsage
fi

echo
while read -r "thisLine"; do 

  countFields=$(echo "$thisLine" | awk '{print NF}')

  # No mangling for single strings  
  if [ "$countFields" = "1" ]; then
    thisOut="$addBefore$thisLine$addAfter"
    echo "$thisOut" >> "$tempFile"
    if [ "$isVerbose" = "Y" ]; then
      echo "$(tput setaf 2)[+]$(tput sgr0) $(tput setaf 4)'$thisLine' - single string - '$thisOut'$(tput sgr0)"
    fi
    
  elif [ "$countFields" = "2" ]; then

    # Check if "first last" or "last, first"  
    checkComma=$(echo "$thisLine" | awk '{print $1}' | grep , --color=never)
    if [ "$checkComma" = "" ]; then
      thisFormat="first last"
      thisFN=$(echo "$thisLine" | awk '{print $1}')
      thisFI=$(echo "$thisLine" | awk '{print $1}' | cut -c1)
      thisLN=$(echo "$thisLine" | awk '{print $2}')
      thisLI=$(echo "$thisLine" | awk '{print $2}' | cut -c1)
    else
      thisFormat="last, first"
      thisFN=$(echo "$thisLine" | awk '{print $2}' | sed 's/ //g')
      thisFI=$(echo "$thisLine" | awk '{print $2}' | sed 's/ //g' | cut -c1)
      thisLN=$(echo "$thisLine" | awk '{print $1}' | sed 's/,//g')
      thisLI=$(echo "$thisLine" | awk '{print $1}' | sed 's/,//g' | cut -c1)
    fi
    
    #jsmith
    if [ "$doFormatA" = "Y" ] || [ "$doFormatAll" = "Y" ]; then
      if [ "$doMax" = "Y" ]; then
        let thisCut=maxLength-1
        thisFormatFirst="$thisFI"
        thisFormatLast=$(echo "$thisLN" | cut -c1-$thisCut)
      else
        thisFormatFirst="$thisFI"
        thisFormatLast="$thisLN"
      fi
      thisOut="$addBefore$thisFormatFirst$thisFormatLast$addAfter"
      echo "$thisOut" >> "$tempFile"
      if [ "$isVerbose" = "Y" ]; then
        echo "$(tput setaf 2)[+]$(tput sgr0) $(tput setaf 6)'$thisLine' - $thisFormat - converted to '$thisOut'$(tput sgr0)"
      fi
    fi
    
    #j~smith
    if [ "$doFormatB" = "Y" ] || [ "$doFormatAll" = "Y" ]; then
      if [ "$doMax" = "Y" ]; then
        let thisCut=maxLength-2
        thisFormatFirst="$thisFI"
        thisFormatLast=$(echo "$thisLN" | cut -c1-$thisCut)
      else
        thisFormatFirst="$thisFI"
        thisFormatLast="$thisLN"
      fi
      thisOut="$addBefore$thisFormatFirst$seperator$thisFormatLast$addAfter"
      echo "$thisOut" >> "$tempFile"
      if [ "$isVerbose" = "Y" ]; then
        echo "$(tput setaf 2)[+]$(tput sgr0) $(tput setaf 6)'$thisLine' - $thisFormat - converted to '$thisOut'$(tput sgr0)"
      fi
    fi
    
    #jxsmith
    if [ "$doFormatC" = "Y" ] || [ "$doFormatAll" = "Y" ]; then
      if [ "$doMax" = "Y" ]; then
        let thisCut=maxLength-2
        thisFormatFirst="$thisFI"
        thisFormatLast=$(echo "$thisLN" | cut -c1-$thisCut)
      else
        thisFormatFirst="$thisFI"
        thisFormatLast="$thisLN"
      fi
      thisOut="$addBefore$thisFormatFirst[a-z]$thisFormatLast$addAfter"
      for thisMI in {a..z}; do
        echo "$addBefore$thisFormatFirst$thisMI$thisFormatLast$addAfter" >> "$tempFile"
      done
      if [ "$isVerbose" = "Y" ]; then
        echo "$(tput setaf 2)[+]$(tput sgr0) $(tput setaf 3)'$thisLine' - $thisFormat - generated '$thisOut'$(tput sgr0)"
      fi
    fi
    
    #jxs
    if [ "$doFormatD" = "Y" ] || [ "$doFormatAll" = "Y" ]; then
      thisFormatFirst="$thisFI"
      thisFormatLast="$thisLI"
      thisOut="$addBefore$thisFormatFirst[a-z]$thisFormatLast$addAfter"
      for thisMI in {a..z}; do
        echo "$addBefore$thisFormatFirst$thisMI$thisFormatLast$addAfter" >> "$tempFile"
      done
      if [ "$isVerbose" = "Y" ]; then
        echo "$(tput setaf 2)[+]$(tput sgr0) $(tput setaf 3)'$thisLine' - $thisFormat - generated '$thisOut'$(tput sgr0)"
      fi
    fi

    #john~smith
    if [ "$doFormatE" = "Y" ] || [ "$doFormatAll" = "Y" ]; then
      thisFormatFirst="$thisFN"
      thisFormatLast="$thisLN"
      thisOut="$addBefore$thisFormatFirst$seperator$thisFormatLast$addAfter"
      echo "$thisOut" >> "$tempFile"
      if [ "$isVerbose" = "Y" ]; then
        echo "$(tput setaf 2)[+]$(tput sgr0) $(tput setaf 6)'$thisLine' - $thisFormat - converted to '$thisOut'$(tput sgr0)"
      fi
    fi

    #johnsmith
    if [ "$doFormatF" = "Y" ] || [ "$doFormatAll" = "Y" ]; then
      thisFormatFirst="$thisFN"
      thisFormatLast="$thisLN"
      thisOut="$addBefore$thisFormatFirst$thisFormatLast$addAfter"
      echo "$thisOut" >> "$tempFile"
      if [ "$isVerbose" = "Y" ]; then
        echo "$(tput setaf 2)[+]$(tput sgr0) $(tput setaf 6)'$thisLine' - $thisFormat - converted to '$thisOut'$(tput sgr0)"
      fi
    fi

    #johnxsmith
    if [ "$doFormatG" = "Y" ] || [ "$doFormatAll" = "Y" ]; then
      thisFormatFirst="$thisFN"
      thisFormatLast="$thisLN"
      thisOut="$addBefore$thisFormatFirst[a-z]$thisFormatLast$addAfter"
      for thisMI in {a..z}; do
        echo "$addBefore$thisFormatFirst$thisMI$thisFormatLast$addAfter" >> "$tempFile"
      done
      if [ "$isVerbose" = "Y" ]; then
        echo "$(tput setaf 2)[+]$(tput sgr0) $(tput setaf 3)'$thisLine' - $thisFormat - generated '$thisOut'$(tput sgr0)"
      fi
    fi
    
    #johns
    if [ "$doFormatH" = "Y" ] || [ "$doFormatAll" = "Y" ]; then
      if [ "$doMax" = "Y" ]; then
        let thisCut=maxLength-1
        thisFormatFirst=$(echo "$thisFN" | cut -c1-$thisCut)
        thisFormatLast="$thisLI"
      else
        thisFormatFirst="$thisFN"
        thisFormatLast="$thisLI"
      fi
      thisOut="$addBefore$thisFormatFirst$thisFormatLast$addAfter"
      echo "$thisOut" >> "$tempFile"
      if [ "$isVerbose" = "Y" ]; then
        echo "$(tput setaf 2)[+]$(tput sgr0) $(tput setaf 6)'$thisLine' - $thisFormat - converted to '$thisOut'$(tput sgr0)"
      fi
    fi

    #johnxs
    if [ "$doFormatI" = "Y" ] || [ "$doFormatAll" = "Y" ]; then
      if [ "$doMax" = "Y" ]; then
        let thisCut=maxLength-2
        thisFormatFirst=$(echo "$thisFN" | cut -c1-$thisCut)
        thisFormatLast="$thisLI"
      else
        thisFormatFirst="$thisFN"
        thisFormatLast="$thisLI"
      fi
      thisOut="$addBefore$thisFormatFirst[a-z]$thisFormatLast$addAfter"
      for thisMI in {a..z}; do
        echo "$addBefore$thisFormatFirst$thisMI$thisFormatLast$addAfter" >> "$tempFile"
      done
      if [ "$isVerbose" = "Y" ]; then
        echo "$(tput setaf 2)[+]$(tput sgr0) $(tput setaf 3)'$thisLine' - $thisFormat - generated '$thisOut'$(tput sgr0)"
      fi
    fi
    
    #john
    if [ "$doFormatJ" = "Y" ] || [ "$doFormatAll" = "Y" ]; then
      if [ "$doMax" = "Y" ]; then
        let thisCut=maxLength
        thisFormatFirst=$(echo "$thisFN" | cut -c1-$thisCut)
      else
        thisFormatFirst="$thisFN"
      fi
      thisOut="$addBefore$thisFormatFirst$addAfter"
      echo "$thisOut" >> "$tempFile"
      if [ "$isVerbose" = "Y" ]; then
        echo "$(tput setaf 2)[+]$(tput sgr0) $(tput setaf 6)'$thisLine' - $thisFormat - converted to '$thisOut'$(tput sgr0)"
      fi
    fi
    
    #smith
    if [ "$doFormatK" = "Y" ] || [ "$doFormatAll" = "Y" ]; then
      if [ "$doMax" = "Y" ]; then
        let thisCut=maxLength
        thisFormatLast=$(echo "$thisLN" | cut -c1-$thisCut)
      else
        thisFormatLast="$thisLN"
      fi
      thisOut="$addBefore$thisFormatLast$addAfter"
      echo "$thisOut" >> "$tempFile"
      if [ "$isVerbose" = "Y" ]; then
        echo "$(tput setaf 2)[+]$(tput sgr0) $(tput setaf 6)'$thisLine' - $thisFormat - converted to '$thisOut'$(tput sgr0)"
      fi
    fi
    
    #smithj
    if [ "$doFormatL" = "Y" ] || [ "$doFormatAll" = "Y" ]; then
      if [ "$doMax" = "Y" ]; then
        let thisCut=maxLength-1
        thisFormatFirst="$thisFI"
        thisFormatLast=$(echo "$thisLN" | cut -c1-$thisCut)
      else
        thisFormatFirst="$thisFI"
        thisFormatLast="$thisLN"
      fi
      thisOut="$addBefore$thisFormatLast$thisFormatFirst$addAfter"
      echo "$thisOut" >> "$tempFile"
      if [ "$isVerbose" = "Y" ]; then
        echo "$(tput setaf 2)[+]$(tput sgr0) $(tput setaf 6)'$thisLine' - $thisFormat - converted to '$thisOut'$(tput sgr0)"
      fi
    fi
    
    #smithjx
    if [ "$doFormatM" = "Y" ] || [ "$doFormatAll" = "Y" ]; then
      if [ "$doMax" = "Y" ]; then
        let thisCut=maxLength-2
        thisFormatFirst="$thisFI"
        thisFormatLast=$(echo "$thisLN" | cut -c1-$thisCut)
      else
        thisFormatFirst="$thisFI"
        thisFormatLast="$thisLN"
      fi
      thisOut="$addBefore$thisFormatLast$thisFormatFirst[a-z]$addAfter"
      for thisMI in {a..z}; do
        echo "$addBefore$thisFormatLast$thisFormatFirst$thisMI$addAfter" >> "$tempFile"
      done
      if [ "$isVerbose" = "Y" ]; then
        echo "$(tput setaf 2)[+]$(tput sgr0) $(tput setaf 3)'$thisLine' - $thisFormat - generated '$thisOut'$(tput sgr0)"
      fi
    fi
    
  else
    echo "$(tput setaf 1)[-] '$thisLine' - not recognized as one string or two substrings$(tput sgr0)"
  fi

done < "$nameFile"

if [ -f "$tempFile" ]; then
  cat "$tempFile" | tr 'A-Z' 'a-z' | sort -u > "$outFile"
  rm "$tempFile"
  echo
  tput setaf 2
  wc -l "$outFile" | sed 's/ / unique lines generated: /g'
  tput sgr0
fi

echo
echo "=========================================[ fin ]========================================="
echo
