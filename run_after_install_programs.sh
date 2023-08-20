#!/bin/sh
error() {
  printf "Error: %s\n" "$1" 1>&2
  exit 1
}

symlink_programs() {
  find -L . -maxdepth 1 -type f -perm -a=x -exec ln -s -r -f {} ~/programs/bin \;
}

install_rust_programs() (
  printf "Installing Rust programs...\n"
  cd ~/programs/rust || error "rust directory not found"
  cargo build --release
  cd ~/programs/rust/target/release || error "rust build directory not found"
  symlink_programs
)

install_rust_programs
