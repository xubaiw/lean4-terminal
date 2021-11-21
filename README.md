# lean4-terminal

WIP: event feature not finished.

A Lean package for programming the terminal.

This pacakge is mostly "translated" from Rust's [`crossterm`](https://github.com/crossterm-rs/crossterm).

## Example

```lean
import Terminal

open Terminal

def main : IO Unit := do
  queue #[
    Terminal.SetBackgroundColor.mk Color.red
  ]
  IO.println "Hello, world"
```

## Limitations
- `stdout` only, until IO primitives for Lean 4 is more usable.
- ANSI only (Win 10 and *nix). Adding support for legacy systems is important, but not our focus now.
- `poll` unavailable, lacking of async IO in Lean 4.