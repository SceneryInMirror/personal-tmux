#!/usr/bin/env bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

tmux_interpolation=(
  "\#{username}"
  "\#{hostname}"
)

tmux_commands=(
  "#($CURRENT_DIR/scripts/username.sh)"
  "#($CURRENT_DIR/scripts/hostname.sh)"
)

get_tmux_option() {
  local option="$1"
  local default_valu="$2"
  local option_value="$(tmux show-option -gqv "$option")"
  if [ -z "$option_value" ]; then
    echo "$default_value"
  else
    echo "$option_value"
  fi
}

do_interpolation() {
  local all_interpolated="$1"
  for ((i=0; i<${#tmux_commands[@]}; i++)); do
    all_interpolated=${all_interpolated//${tmux_interpolation[$i]}/${tmux_commands[$i]}}
  done
  echo "$all_interpolated"
}

main() {
  local option="status-right"
  local option_value=$(get_tmux_option "$option")
  local new_option_value=$(do_interpolation "$option_value")
  tmux set-option -gq "$option" "$new_option_value"
}

main
