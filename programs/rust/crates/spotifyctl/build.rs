use clap::{CommandFactory, ValueEnum};
use clap_complete::{generate_to, Shell};
use std::ffi::OsString;
use std::fs;
use std::io::Error;

include!("src/cli.rs");

fn main() -> Result<(), Error> {
    println!("cargo:rerun-if-changed=src/cli.rs");
    let completions_dir = OsString::from("../../target/completions");
    fs::create_dir_all(&completions_dir)?;

    let mut cmd = Cli::command();
    for &shell in Shell::value_variants() {
        generate_to(shell, &mut cmd, "spotifyctl", &completions_dir)?;
    }

    Ok(())
}
