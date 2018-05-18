#!/bin/bash

set -eu
set -o pipefail

CWD="$(dirname -- "$0")"

function verify_installation() {
  local cmd="$1"
  local program="$2"

  if ! command -v "$cmd" > /dev/null; then
    echo "Must have $program installed"
  fi
}

function start_server() {
  pushd "$CWD" > /dev/null

  export GOPATH="$PWD"
  export PATH="${PATH}:${GOPATH}/bin"

  echo 'Installing server...'
  go build -o "${GOPATH}/bin/goaway-server" server

  echo 'Starting server in background...'
  goaway-server &
  trap "killall goaway-server" EXIT

  popd > /dev/null
}

function run_demo() (
  pushd "${CWD}/src/client" > /dev/null

  echo 'Installing client...'
  bundle install > /dev/null

  echo -e 'Running demo...\n\n\n'
  ruby client.rb

  popd > /dev/null
)

function main() {
  verify_installation go go
  verify_installation ruby ruby
  verify_installation bundle bundler

  start_server
  run_demo
}

main
