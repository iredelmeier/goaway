#!/bin/bash

CWD="$(dirname -- "$0")"
PROTOS_IN="${CWD}/src/proto"
RUBY_OUT="${CWD}/src/ruby/lib"
GO_PACKAGE="${CWD}/src/go"
GO_OUT="${GO_PACKAGE}/goaway"

RUBY_PROTOC_PLUGIN="$(which grpc_tools_ruby_protoc_plugin)"
: "${RUBY_PROTOC_PLUGIN:?"Did not find grpc_tools_ruby_protoc_plugin"}"

mkdir -p "$RUBY_OUT"

protoc \
  --go_out=plugins=grpc:"${GO_OUT}" \
  --ruby_out="$RUBY_OUT" \
  --plugin=protoc-gen-grpc="$RUBY_PROTOC_PLUGIN" \
  --grpc_out="$RUBY_OUT" \
  -I="${PROTOS_IN}" \
  "${PROTOS_IN}/"*.proto
