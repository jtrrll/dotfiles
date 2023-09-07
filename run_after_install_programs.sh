#!/bin/sh
error() {
  printf "Error: %s\n" "$1" 1>&2
  exit 1
}

symlink_programs() {
  sudo mkdir -p /usr/local/bin
  sudo find -L . -maxdepth 1 -type f -perm -a=x -exec ln -s -r -f {} /usr/local/bin \;
}

symlink_completions() {
  sudo mkdir -p /usr/local/completions
  sudo find -L . -type f -exec ln -s -r -f {} /usr/local/completions \;
}

install_rust_programs() (
  if command -v cargo > /dev/null; then
    printf "Installing Rust programs...\n"
    cd ~/.local/share/chezmoi/programs/rust || error "rust directory not found"
    cargo build --release --quiet
    cd ~/.local/share/chezmoi/programs/rust/target/release || error "rust build directory not found"
    symlink_programs
    cd ~/.local/share/chezmoi/programs/rust/target/completions || error "rust shell completions directory not found"
    find -L . -type f ! -iname "*.*" -exec mv -- {} {}".zsh" \;
    symlink_completions
    printf "Installed Rust programs\n"
  fi
)

sudo printf "Installing custom programs...\n"
install_rust_programs
printf "All custom programs installed\n"
