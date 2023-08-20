#!/bin/sh
error() {
  printf "Error: %s\n" "$1" 1>&2
  exit 1
}

usage() {
  program_name=$(basename "$0")
  cat <<USAGE
Usage:
  $program_name -h | --help               Show usage and available commands
  $program_name get                       Get the current volume
  $program_name set <level>               Set the volume to the specified level in range [0, 100]
  $program_name (raise | up) <amount>     Raise the volume by the specified amount (Upper bound = 100)
  $program_name (lower | down) <amount>   Lower the volume by the specified amount (Lower bound = 0)
  $program_name toggle-input-mute         Toggle input mute
  $program_name toggle-output-mute        Toggle output mute
USAGE
}

get_volume() {
  pactl get-sink-volume @DEFAULT_SINK@ | grep Volume | awk '{print $5}' | tr % " " | awk '{$1=$1};1'
}

set_volume() {
  if [ "$1" -gt 100 ] 2>/dev/null; then
    pactl set-sink-volume @DEFAULT_SINK@ 100%
  else
    pactl set-sink-volume @DEFAULT_SINK@ "$1%"
  fi
  pactl set-sink-mute @DEFAULT_SINK@ no
}

raise_volume() {
  if [ "$(get_volume)" -gt 95 ]; then
    pactl set-sink-volume @DEFAULT_SINK@ 100%
  else
    pactl set-sink-volume @DEFAULT_SINK@ +5%
  fi
  pactl set-sink-mute @DEFAULT_SINK@ no
}

lower_volume() {
  pactl set-sink-volume @DEFAULT_SINK@ -5%
  pactl set-sink-mute @DEFAULT_SINK@ no
}

toggle_input_mute() {
  pactl set-source-mute @DEFAULT_SOURCE@ toggle
}

toggle_output_mute() {
  pactl set-sink-mute @DEFAULT_SINK@ toggle
}

if [ "$#" -lt 1 ]; then
  usage
  exit 1
fi

case "$1" in
  -h | --help)
    usage
    exit 0
  ;;
  get)
    shift
    if [ "$#" -ne 0 ]; then
      error "Invalid arguments"
    fi
    get_volume
  ;;
  set)
    shift
    if [ "$#" -ne 1 ]; then
      error "Invalid arguments"
    fi
    set_volume "$1"
  ;;
  raise | up)
    shift
    if [ "$#" -ne 1 ]; then
      error "Invalid arguments"
    fi
    raise_volume "$1"
  ;;
  lower | down)
    shift
    if [ "$#" -ne 1 ]; then
      error "Invalid arguments"
    fi
    lower_volume "$1"
  ;;
  toggle-input-mute)
    shift
    if [ "$#" -ne 0 ]; then
      error "Invalid arguments"
    fi
    toggle_input_mute
  ;;
  toggle-output-mute)
    shift
    if [ "$#" -ne 0 ]; then
      error "Invalid arguments"
    fi
    toggle_output_mute
  ;;
  *)
    error "Invalid command"
  ;;
esac
