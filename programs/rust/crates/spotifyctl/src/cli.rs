use clap::{Parser, Subcommand};
use mpris::LoopStatus;

#[derive(Parser, Debug)]
#[command(about, author, long_about = None, version)]
#[command(propagate_version = true)]
pub struct Cli {
    #[command(subcommand)]
    pub command: Command,
}

#[derive(Subcommand, Debug)]
pub enum Command {
    /// Starts or resumes playback
    Play,
    /// Pauses playback
    Pause,
    /// Toggles playback between playing and paused
    PlayPause,
    /// Stops playback
    Stop,
    /// Skips to the next track in the tracklist. If there is no next track, stop playback
    Next,
    /// Skips to the previous track in the tracklist. If there is no previous track, stop playback
    Previous,
    /// Gets the current track position in seconds
    GetPosition,
    /// Seeks forward/backward by OFFSET seconds
    Seek {
        /// The number of seconds to seek forward. A negative number seeks backwards
        offset: i16,
    },
    /// Gets the current volume as an integer in range [0, 100]
    GetVolume,
    /// Sets the current volume to LEVEL, an integer in range [0, 100]
    SetVolume {
        /// The integer in range [0, 100] to set the volume to
        level: u8,
    },
    /// Gets the playback status of the player. Must be one of: "Playing", "Paused", "Stopped"
    GetPlayback,
    /// Gets the metadata information for the current track. If a KEY is specified, retrieves only that corresponding value if found
    GetMetadata {
        /// The key associated with a metadata value
        key: Option<String>,
    },
    /// Get loop status. Must be one of "None", "Track", or "Playlist"
    GetLoop,
    /// Set loop status. Must be one of "None", "Track", or "Playlist"
    SetLoop {
        /// Loop status. Must be one of "None", "Track", or "Playlist"
        status: LoopStatus,
    },
    /// Toggle loop status between "None", "Track", and "Playlist" in that order
    ToggleLoop,
    /// Get shuffle status. Either true or false
    GetShuffle,
    /// Set shuffle status. Either true or false
    SetShuffle {
        /// Shuffle status. Either true or false
        #[clap(action = clap::ArgAction::Set)]
        state: bool,
    },
    /// Toggle shuffle status between true or false
    ToggleShuffle,
}

#[test]
fn verify_cli() {
    use clap::CommandFactory;
    Cli::command().debug_assert()
}
