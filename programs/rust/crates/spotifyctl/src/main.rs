use clap::Parser;
use spotifyctl::{cli::Cli, execute_command, new_spotify_player, start_spotify_process};
use std::{thread, time::Duration};

fn main() -> Result<(), Box<dyn std::error::Error>> {
    let cli = Cli::parse();

    let spotify_player = match new_spotify_player() {
        Ok(player) => player,
        Err(..) => {
            start_spotify_process()?;
            loop {
                match new_spotify_player() {
                    Ok(player) => break player,
                    Err(_) => thread::sleep(Duration::from_millis(50)),
                }
            }
        }
    };
    execute_command(spotify_player, cli.command)
}
