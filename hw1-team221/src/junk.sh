#!/bin/bash
###############################################################################
#Author: Stephen James Connelly
#Date: January 28th, 2023
#Name: junk.sh
#Work Cited:
# -https://sookocheff.com/post/bash/parsing-bash-script-arguments-with-shopts/
# -https://www.cyberciti.biz/faq/howto-check-if-a-directory-exists-in-a-bash-shellscript/
# -https://unix.stackexchange.com/questions/255652/linux-bash-if-statement-inside-for-loop
# -https://stackoverflow.com/questions/12711786/convert-command-line-arguments-into-an-array-in-bash
###############################################################################
make_dir (){
  readonly DIR=".junk"
  if [ ! -d ~/"$DIR" ]; then
    mkdir ~/"$DIR"
  fi
}
file="$0"

#instatiates an args array
array=( "$@" )
arraylength=${#array[@]}

#parse a command line arguments and verifies legitimacy
usage_printer () {
cat << EOF
Usage: $(basename "$file") [-hlp] [list of files]
    -h: Display help.
    -l: List junked files.
    -p: Purge all files.
    [list of files] with no other arguments to junk those files.
EOF
}

h_flag=0
l_flag=0
p_flag=0

while getopts ":hlp" opt; do
  case ${opt} in
    h ) # process option h. "Help," lists how to use command.
      if [ "$#" -gt 1 ]; then
        for (( i=0; i = $# || i < $#; i++ )); do
          if [ "$1" != "-h" ]; then
            echo "Error: Too many options enabled." >&2
            usage_printer
            exit 1
          fi
          shift "$((OPTIND-1))"
        done
      fi
      h_flag=1
      ;;
    l ) # process option l. List junked files.
      if [ "$#" -gt 1 ]; then
        for (( i=0; i = $# || i < $#; i++ )); do
          if [ "$1" != "-l" ]; then
            echo "Error: Too many options enabled." >&2
            usage_printer
            exit 1
          fi
          shift "$((OPTIND-1))"
        done
      fi
      l_flag=1
      ;;
    p ) # process option p. Purge all files.
      p_flag=1
      ;;
    \?)
      echo "Error: Unknown option '-$OPTARG'." >&2
      usage_printer
      exit 1
      ;;
  esac
done

make_dir

if (( h_flag == 1 )); then
  usage_printer
fi

if (( l_flag == 1 )); then
  ls -lAF ~/.junk
fi

if (( p_flag == 1 )); then
  rm ~/.junk/* 2> /dev/null
  rm -r inner ~/.[!.]* 2> /dev/null
fi

if (( h_flag + l_flag + p_flag == 0 )) && (( $# != 0 )); then
  for (( i=0; i = $# || i < $#; i++ )); do
    if [ -f "$PWD"/"$1" ] || [ -a "$PWD"/".$#" ] || [ -d "$PWD"/"$1" ]; then
      if [ -f "$PWD"/"$1"  ]; then
        chmod 660 "$PWD"/"$1"
      elif [ -d "$PWD"/"$1" ] || [ -a "$PWD"/".$#" ]; then
        chmod 770 "$PWD"/"$1"
      fi
      mv "$1" ~/.junk #move that file to .junk
    elif [ ! -f "$PWD"/"$#" ] || [ ! -a "$PWD"/".$#" ] || [ ! -d "$PWD"/"$1" ]; then #else
      echo "Warning: '$1' not found">&2
    fi
    shift "$((OPTIND))"
  done
elif (( h_flag + l_flag + p_flag == 0 )) && (( arraylength == 0 )); then
  usage_printer
  exit 1
fi

