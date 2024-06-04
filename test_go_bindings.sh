#!/bin/bash
set -euxo pipefail

SCRIPT_DIR="${SCRIPT_DIR:-$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )}"
ROOT_DIR="$SCRIPT_DIR"

VDF_PACKAGE="$ROOT_DIR/vdf"
BINDINGS_DIR="$ROOT_DIR/go_bindings"
BINARIES_DIR="$ROOT_DIR/target/release"

# Build the Rust VDF package in release mode
cargo build -p vdf --release

# Generate Go bindings
pushd "$VDF_PACKAGE" > /dev/null
uniffi-bindgen-go src/lib.udl -o "$BINDINGS_DIR"/generated -c uniffi.toml

# Run the Go program that uses the bindings 
pushd "$BINDINGS_DIR" > /dev/null
LD_LIBRARY_PATH="${LD_LIBRARY_PATH:-}:$BINARIES_DIR" \
	CGO_LDFLAGS="-lvdf -L$BINARIES_DIR -ldl" \
	CGO_ENABLED=1 \
	LC_RPATH="$BINARIES_DIR" \
  go run main.go
