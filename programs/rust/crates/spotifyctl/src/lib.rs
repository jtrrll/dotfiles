pub mod cli;
use cli::Command;
use mpris::{FindingError, LoopStatus, Player, PlayerFinder};
use std::{cmp::min, fmt, io, process};
use thiserror::Error;

#[derive(Debug, Error)]
struct KeyNotFound;
impl fmt::Display for KeyNotFound {
    fn fmt(&self, f: &mut fmt::Formatter) -> fmt::Result {
        write!(f, "key not found")
    }
}

pub fn new_spotify_player() -> Result<Player, FindingError> {
    PlayerFinder::new()?.find_by_name("spotify")
}

pub fn start_spotify_process() -> io::Result<process::Child> {
    process::Command::new("spotify")
        .stderr(process::Stdio::null())
        .spawn()
}

pub fn execute_command(
    spotify_player: Player,
    cmd: Command,
) -> Result<(), Box<dyn std::error::Error>> {
    match cmd {
        Command::Play => spotify_player.play()?,
        Command::Pause => spotify_player.pause()?,
        Command::PlayPause => spotify_player.play_pause()?,
        Command::Stop => spotify_player.stop()?,
        Command::Next => spotify_player.next()?,
        Command::Previous => spotify_player.previous()?,
        Command::GetPosition => println!("{}", spotify_player.get_position()?.as_secs()),
        Command::Seek { offset } => spotify_player.seek(i64::from(offset) * 1000000)?,
        Command::GetVolume => println!("{}", (spotify_player.get_volume()? * 100.0).round()),
        Command::SetVolume { level } => {
            spotify_player.set_volume(min(level, 100) as f64 / 100.0)?
        }
        Command::GetPlayback => println!("{:?}", spotify_player.get_playback_status()?),
        Command::GetMetadata { key } => {
            let metadata = spotify_player.get_metadata()?;
            match key {
                Some(key) => {
                    let value = metadata.get(&key);
                    match value {
                        Some(value) => println!("{:?}", value),
                        None => Err(KeyNotFound)?,
                    }
                }
                None => println!("{:#?}", metadata),
            }
        }
        Command::GetLoop => println!("{:?}", spotify_player.get_loop_status()?),
        Command::SetLoop { status } => spotify_player.set_loop_status(status)?,
        Command::ToggleLoop {} => match spotify_player.get_loop_status()? {
            LoopStatus::None => spotify_player.set_loop_status(LoopStatus::Playlist)?,
            LoopStatus::Playlist => spotify_player.set_loop_status(LoopStatus::Track)?,
            LoopStatus::Track => spotify_player.set_loop_status(LoopStatus::None)?,
        },
        Command::GetShuffle => println!("{}", spotify_player.get_shuffle()?),
        Command::SetShuffle { state } => spotify_player.set_shuffle(state)?,
        Command::ToggleShuffle => spotify_player.set_shuffle(!spotify_player.get_shuffle()?)?,
    };
    Ok(())
}
