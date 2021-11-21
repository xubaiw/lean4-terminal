# lean4-terminal

WIP: event feature not finished.

A Lean package for programming the terminal.

This pacakge is mostly "translated" from Rust's [`crossterm`](https://github.com/crossterm-rs/crossterm).

## Example

```lean
import Terminal

open Terminal
open Color (background blue green red reset yellow')

def main : IO Unit :=
  IO.println s!"{red}He{reset}llo, {blue}{green background}wor{yellow'}ld!"
```

## Limitations
- `stdout` only, until IO primitives for Lean 4 is more usable.
- ANSI only (Win 10 and *nix). Adding support for legacy systems is important, but not our focus now.
- `poll` unavailable, lacking of async IO in Lean 4.