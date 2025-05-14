#!/bin/bash

function server () {
  while true; do
    if read -r method path version; then
      if [[ "$method" == "GET" ]]; then
        echo "HTTP/1.1 200 OK"
      else
        echo "HTTP/1.1 400 Bad Request"
      fi
    else
      break
    fi
  done
}

coproc SERVER_PROCESS { server; }

netcat -lv 2345 <&${SERVER_PROCESS[0]} >&${SERVER_PROCESS[1]}
