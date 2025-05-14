#!/bin/bash

function server () {
  while true; do
    if read -r method path version; then
      if [[ "$method" == "GET" ]]; then
        filepath="./www$path"
        if [[ -f "$filepath" ]]; then
          echo -e "HTTP/1.1 200 OK\r\n"
          cat "$filepath"
        else
          echo -e "HTTP/1.1 404 Not Found\r\n"
        fi
      else
        echo -e "HTTP/1.1 400 Bad Request\r\n"
      fi
    else
      break
    fi
  done
}

coproc SERVER_PROCESS { server; }

netcat -lv 2345 <&${SERVER_PROCESS[0]} >&${SERVER_PROCESS[1]}
