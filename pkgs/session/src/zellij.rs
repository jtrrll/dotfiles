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

/// Names of currently live zellij sessions.
pub fn live_sessions() -> BTreeSet<String> {
    let mut set = BTreeSet::new();
    if let Ok(o) = zellij(&["list-sessions", "--no-formatting", "--short"]) {
        if o.status {
            for line in o.stdout.lines() {
                let name = line.trim();
                if !name.is_empty() {
                    set.insert(name.to_string());
                }
            }
        }
    }
    set
}

/// Layout opened as the first tab of a freshly created session.
const INITIAL_LAYOUT: &str = "plan";

/// Id of the default tab zellij creates in every new session.
const DEFAULT_TAB_ID: &str = "0";

/// Attach to the session with the given slug in the foreground, first
/// creating it (with the initial layout as its only tab) if it doesn't exist.
/// Existing sessions, live or resurrectable, are attached to as they are.
pub fn start(slug: &str, cwd: &Path) -> Result<(), String> {
    if !live_sessions().contains(slug) {
        create(slug, cwd)?;
    }
    let status = Command::new("zellij")
        .arg("attach")
        .arg(slug)
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

/// Create a detached session with zellij's default layout, then replace its
/// default tab with the initial layout so the default layout supplies the bars.
fn create(slug: &str, cwd: &Path) -> Result<(), String> {
    let created = Command::new("zellij")
        .args(["attach", "--create-background", slug])
        .current_dir(cwd)
        .output()
        .map_err(|e| format!("failed to create zellij session: {e}"))?;
    if !created.status.success() {
        return Err(format!(
            "failed to create zellij session: {}",
            String::from_utf8_lossy(&created.stderr).trim()
        ));
    }

    let cwd = cwd.to_string_lossy();
    let mut last_error = String::new();
    for _ in 0..50 {
        match zellij(&[
            "--session",
            slug,
            "action",
            "new-tab",
            "--layout",
            INITIAL_LAYOUT,
            "--cwd",
            &cwd,
        ]) {
            Ok(o) if o.status => {
                return zellij(&[
                    "--session",
                    slug,
                    "action",
                    "close-tab",
                    "--tab-id",
                    DEFAULT_TAB_ID,
                ])
                .and_then(|o| {
                    if o.status {
                        Ok(())
                    } else {
                        Err(format!("closing default tab: {}", o.stderr.trim()))
                    }
                });
            }
            Ok(o) => last_error = o.stderr.trim().to_string(),
            Err(e) => last_error = e,
        }
        sleep(Duration::from_millis(100));
    }
    Err(format!(
        "opening '{INITIAL_LAYOUT}' layout in new session '{slug}': {last_error}"
    ))
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
