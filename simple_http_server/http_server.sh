#!/bin/bash

function server () {
  while true; do
    if read -r message; then
      echo "You said:'$message'"
    else
      break  # Exit if input stream is closed
    fi
  done
}

coproc SERVER_PROCESS { server; }

netcat -lv 2345 <&${SERVER_PROCESS[0]} >&${SERVER_PROCESS[1]}
