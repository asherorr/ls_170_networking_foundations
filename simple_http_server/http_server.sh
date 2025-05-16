#!/bin/bash

function server() {
  while true; do
    # Read the request line: METHOD PATH VERSION
    if ! IFS=' ' read -r method path version; then
      # End of input or error - exit loop
      break
    fi

    # Debug print (uncomment to see requests)
    # echo "DEBUG: Received request: $method $path $version" >&2

    # Read and discard all HTTP headers until an empty line
    while IFS= read -r header_line; do
      [[ "$header_line" == $'\r' || -z "$header_line" ]] && break
    done

    # Remove leading slash from path, e.g. /lion.html -> lion.html
    path="${path#/}"

    if [[ "$method" == "GET" ]]; then
      if [[ -f "./www/$path" ]]; then
        content_length=$(wc -c < "./www/$path")
        echo -ne "HTTP/1.1 200 OK\r\nContent-Type: text/html; charset=utf-8\r\nContent-Length: $content_length\r\n\r\n"
        cat "./www/$path"
      else
        echo -ne "HTTP/1.1 404 Not Found\r\nContent-Length: 0\r\n\r\n"
      fi
    else
      echo -ne "HTTP/1.1 400 Bad Request\r\nContent-Length: 0\r\n\r\n"
    fi
  done
}

coproc SERVER_PROCESS { server; }

netcat -lkv 2345 <&"${SERVER_PROCESS[0]}" >&"${SERVER_PROCESS[1]}"
