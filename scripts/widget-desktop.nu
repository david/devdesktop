#!/usr/bin/env nu

use widget.nu fade
use wm.nu
use ws.nu

def main [] {
  print --no-newline (ansi cursor_off)

  render

  wm events | where name == "workspace" | each { |e| render }
}

def render [] {
  print --no-newline (tput cup 0 0)

  let ws = (wm ws)
  let root = ($ws | ws root | str replace $"($env.HOME)/" "")

  print $" ('󰕮 ' | fade) ($ws | get name) (' ' | fade) ($root)(ansi erase_line_from_cursor_to_end)"

  let branch = (git branch --show-current e> /dev/null | str trim)

  if ($branch | is-not-empty) {
    print --no-newline $" (' ' | fade) ($branch | str trim)(ansi erase_line_from_cursor_to_end)"
  } 

  print --no-newline (ansi clear_screen_from_cursor_to_end)
}
