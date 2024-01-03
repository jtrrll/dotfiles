#!/bin/sh
error() {
  printf "\033[91mError: %s\033[0m\n" "$1" 1>&2
  exit 1
}

indent() {
  if [ "$1" -lt 1 ]; then
    error "no indents specified"
  fi
  i=0; while [ "$i" -lt "$1" ]; do  
    printf "  "
    i=$(( i + 1 ))
  done
}

printf "Checking dependencies...\n"
if [ ! -e "dependencies.json" ]; then
  error "no dependencies found"
fi

# Check installed fonts
indent 1 && printf "\033[1m%s\033[0m\n" "Fonts"
jq -r '.Fonts | sort | .[]' dependencies.json |
while IFS= read -r font; do
  if fc-list : family | grep -x "$font" > /dev/null; then
    indent 2 && printf "\033[92m%s installed\033[0m\n" "$font"
  else
    indent 2 && printf "\033[91m%s not installed\033[0m\n" "$font"
  fi
done

# Check installed programs
indent 1 && printf "\033[1m%s\033[0m\n" "Programs"
jq -r '.Programs | keys[]' dependencies.json |
while IFS= read -r category; do
  indent 2 && printf "\033[1m%s\033[0m\n" "$category"
  jq -r ".Programs.\"$category\" | sort[]" dependencies.json |
  while IFS= read -r program; do
    if command -v "$program" > /dev/null; then
      indent 3 && printf "\033[92m%s installed\033[0m\n" "$program"
    else
      indent 3 && printf "\033[91m%s not installed\033[0m\n" "$program"
    fi
  done
done
