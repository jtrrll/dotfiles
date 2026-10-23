//! Zellij session control.

use std::collections::BTreeSet;
use std::path::Path;
use std::process::{Command, Stdio};
use std::thread::sleep;
use std::time::Duration;

use crate::git::Output;

fn zellij(args: &[&str]) -> Result<Output, String> {
    let out = Command::new("zellij")
        .args(args)
        .output()
        .map_err(|e| format!("failed to run zellij: {e}"))?;
    Ok(Output {
        status: out.status.success(),
        stdout: String::from_utf8_lossy(&out.stdout).to_string(),
        stderr: String::from_utf8_lossy(&out.stderr).to_string(),
    })
}

const EXITED_MARKER: &str = "(EXITED";

/// Names of zellij sessions, optionally including exited (resurrectable) ones.
fn session_names(include_exited: bool) -> BTreeSet<String> {
    let Ok(o) = zellij(&["list-sessions", "--no-formatting"]) else {
        return BTreeSet::new();
    };
    if !o.status {
        return BTreeSet::new();
    }
    o.stdout
        .lines()
        .filter(|line| include_exited || !line.contains(EXITED_MARKER))
        .filter_map(|line| line.split_whitespace().next())
        .map(str::to_string)
        .collect()
}

/// Names of sessions with a running server.
pub fn live_sessions() -> BTreeSet<String> {
    session_names(false)
}

/// Names of all known sessions, live or exited-but-resurrectable.
fn known_sessions() -> BTreeSet<String> {
    session_names(true)
}

/// Layout opened as the first tab of a freshly created session. It must supply
/// its own bars through a `default_tab_template`.
const INITIAL_LAYOUT: &str = "plan";

/// Run zellij in the foreground, attached to the current terminal.
fn run_foreground(args: &[&str], cwd: &Path) -> Result<(), String> {
    let status = Command::new("zellij")
        .args(args)
        .current_dir(cwd)
        .stdin(Stdio::inherit())
        .stdout(Stdio::inherit())
        .stderr(Stdio::inherit())
        .status()
        .map_err(|e| format!("failed to start zellij: {e}"))?;
    if status.success() {
        Ok(())
    } else {
        Err("zellij exited with an error".to_string())
    }
}

/// Start the session with the given slug in the foreground. A missing session
/// is created with the initial layout as its only tab; an existing one, live
/// or resurrectable, is attached to as it is.
pub fn start(slug: &str, cwd: &Path) -> Result<(), String> {
    if known_sessions().contains(slug) {
        run_foreground(&["attach", slug], cwd)
    } else {
        run_foreground(
            &[
                "--session",
                slug,
                "--new-session-with-layout",
                INITIAL_LAYOUT,
            ],
            cwd,
        )
    }
}

/// Tear down the zellij session with the given slug, if any.
///
/// `kill-session` is asynchronous: it initiates shutdown but returns before the
/// session has fully exited. Deleting too eagerly races that shutdown and
/// leaves the exited session lingering on disk, so wait for the session to
/// leave the live set (bounded) before forcing the delete.
pub fn teardown(slug: &str) {
    let _ = zellij(&["kill-session", slug]);

    for _ in 0..50 {
        if !live_sessions().contains(slug) {
            break;
        }
        sleep(Duration::from_millis(100));
    }

    let _ = zellij(&["delete-session", slug, "--force"]);
}
